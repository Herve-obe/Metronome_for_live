package com.metronomeforlive.metronome_for_live

import android.media.AudioAttributes
import android.media.AudioFormat
import android.media.AudioTrack
import kotlin.math.PI
import kotlin.math.sin
import kotlin.math.min

/**
 * Moteur audio natif haute performance pour le métronome.
 * Utilise AudioTrack en mode streaming pour une latence minimale.
 * Génère les clics de manière synthétique (pas de fichier WAV nécessaire).
 */
class NativeAudioEngine {

    companion object {
        const val SAMPLE_RATE = 44100
        const val CLICK_DURATION_MS = 30    // Durée du clic accent
        const val CLICK_NORMAL_MS = 20      // Durée du clic normal
        const val CLICK_SUB_MS = 15         // Durée du clic subdivision
        const val ACCENT_FREQ = 1500.0      // Fréquence du clic accent (Hz)
        const val NORMAL_FREQ = 1000.0      // Fréquence du clic normal (Hz)
        const val SUB_FREQ = 800.0          // Fréquence du clic subdivision (Hz)
    }

    // Paramètres du métronome (volatiles pour thread-safety)
    @Volatile var bpm: Int = 120
    @Volatile var numerator: Int = 4
    @Volatile var denominator: Int = 4
    @Volatile var subdivision: Int = 0  // 0=none, 1=eighth, 2=triplet, 3=sixteenth
    @Volatile var measureCount: Int = 0 // 0 = infini
    @Volatile var volume: Float = 1.0f

    // État
    @Volatile private var isPlaying = false
    private var audioThread: Thread? = null
    private var audioTrack: AudioTrack? = null

    // Callback pour informer Flutter des beats
    var onBeat: ((beatIndex: Int, measureIndex: Int) -> Unit)? = null
    var onBlockFinished: (() -> Unit)? = null

    // Sons pré-générés
    private val accentClick: ShortArray by lazy { generateClick(ACCENT_FREQ, CLICK_DURATION_MS, 1.0f) }
    private val normalClick: ShortArray by lazy { generateClick(NORMAL_FREQ, CLICK_NORMAL_MS, 0.7f) }
    private val subClick: ShortArray by lazy { generateClick(SUB_FREQ, CLICK_SUB_MS, 0.4f) }

    /**
     * Génère un clic synthétique (onde sinusoïdale avec enveloppe).
     */
    private fun generateClick(frequency: Double, durationMs: Int, amplitude: Float): ShortArray {
        val numSamples = (SAMPLE_RATE * durationMs) / 1000
        val samples = ShortArray(numSamples)
        for (i in 0 until numSamples) {
            val t = i.toDouble() / SAMPLE_RATE
            // Sine wave
            val sine = sin(2.0 * PI * frequency * t)
            // Envelope: attack 2ms, release rest
            val attackSamples = (SAMPLE_RATE * 0.002).toInt()
            val envelope = if (i < attackSamples) {
                i.toFloat() / attackSamples
            } else {
                1.0f - ((i - attackSamples).toFloat() / (numSamples - attackSamples))
            }
            val sample = (sine * envelope * amplitude * Short.MAX_VALUE).toInt()
            samples[i] = sample.coerceIn(Short.MIN_VALUE.toInt(), Short.MAX_VALUE.toInt()).toShort()
        }
        return samples
    }

    /**
     * Initialise l'AudioTrack.
     */
    fun init() {
        val bufferSize = AudioTrack.getMinBufferSize(
            SAMPLE_RATE,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        )

        audioTrack = AudioTrack.Builder()
            .setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_MEDIA)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build()
            )
            .setAudioFormat(
                AudioFormat.Builder()
                    .setSampleRate(SAMPLE_RATE)
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build()
            )
            .setBufferSizeInBytes(bufferSize)
            .setTransferMode(AudioTrack.MODE_STREAM)
            .setPerformanceMode(AudioTrack.PERFORMANCE_MODE_LOW_LATENCY)
            .build()
    }

    /**
     * Démarre la lecture du métronome dans un thread audio dédié.
     */
    fun start() {
        if (isPlaying) return

        isPlaying = true
        audioTrack?.play()

        audioThread = Thread({
            android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO)
            playLoop()
        }, "MetronomeAudioThread").apply {
            priority = Thread.MAX_PRIORITY
            start()
        }
    }

    /**
     * Arrête le métronome.
     */
    fun stop() {
        isPlaying = false
        audioThread?.join(500)
        audioThread = null
        audioTrack?.pause()
        audioTrack?.flush()
    }

    /**
     * Libère les ressources.
     */
    fun dispose() {
        stop()
        audioTrack?.release()
        audioTrack = null
    }

    /**
     * Boucle principale du métronome.
     * Calcule les timings exacts et écrit les samples directement dans l'AudioTrack.
     */
    private fun playLoop() {
        var currentBeat = 0
        var currentMeasure = 0

        while (isPlaying) {
            val currentBpm = bpm
            val currentNumerator = numerator
            val currentSubdivision = subdivision
            val currentMeasureCount = measureCount
            val currentVolume = volume

            // Nombre de subdivisions par beat
            val subsPerBeat = when (currentSubdivision) {
                1 -> 2  // croches
                2 -> 3  // triolets
                3 -> 4  // doubles-croches
                else -> 1 // pas de subdivision
            }

            // Durée totale d'un beat en samples
            val samplesPerBeat = (SAMPLE_RATE * 60.0 / currentBpm).toInt()
            val samplesPerSub = samplesPerBeat / subsPerBeat

            for (sub in 0 until subsPerBeat) {
                if (!isPlaying) return

                // Détermine quel son jouer
                val clickSamples = when {
                    sub == 0 && currentBeat == 0 -> accentClick  // Premier temps = accent
                    sub == 0 -> normalClick                       // Temps fort = normal
                    else -> subClick                              // Subdivision
                }

                // Callback beat uniquement sur le temps principal (pas les subdivisions)
                if (sub == 0) {
                    onBeat?.invoke(currentBeat, currentMeasure)
                }

                // Écriture du clic
                val volumeAdjusted = applyVolume(clickSamples, currentVolume)
                audioTrack?.write(volumeAdjusted, 0, volumeAdjusted.size)

                // Silence pour compléter la durée de la subdivision
                val silenceSamples = samplesPerSub - clickSamples.size
                if (silenceSamples > 0) {
                    // Écrire le silence en chunks pour pouvoir s'arrêter rapidement
                    val silenceChunkSize = min(silenceSamples, SAMPLE_RATE / 20) // max 50ms chunks
                    var remaining = silenceSamples
                    while (remaining > 0 && isPlaying) {
                        val chunkSize = min(remaining, silenceChunkSize)
                        val silence = ShortArray(chunkSize)
                        audioTrack?.write(silence, 0, chunkSize)
                        remaining -= chunkSize
                    }
                }
            }

            // Avancer au beat suivant
            currentBeat++
            if (currentBeat >= currentNumerator) {
                currentBeat = 0
                currentMeasure++

                // Vérifier si le bloc est terminé
                if (currentMeasureCount > 0 && currentMeasure >= currentMeasureCount) {
                    isPlaying = false
                    onBlockFinished?.invoke()
                    return
                }
            }
        }
    }

    /**
     * Applique le volume aux samples.
     */
    private fun applyVolume(samples: ShortArray, vol: Float): ShortArray {
        if (vol >= 1.0f) return samples
        return ShortArray(samples.size) { i ->
            (samples[i] * vol).toInt().toShort()
        }
    }
}
