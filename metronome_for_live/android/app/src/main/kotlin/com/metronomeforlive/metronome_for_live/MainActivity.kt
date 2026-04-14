package com.metronomeforlive.metronome_for_live

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import android.os.Handler
import android.os.Looper

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "com.metronomeforlive/audio_engine"
    private val EVENT_CHANNEL = "com.metronomeforlive/audio_engine/beats"

    private var audioEngine: NativeAudioEngine? = null
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ─── MethodChannel — commandes depuis Dart ──────────────────
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "init" -> {
                        audioEngine = NativeAudioEngine()
                        audioEngine?.init()
                        setupCallbacks()
                        result.success(null)
                    }

                    "start" -> {
                        audioEngine?.let { engine ->
                            engine.bpm = call.argument<Int>("bpm") ?: 120
                            engine.numerator = call.argument<Int>("numerator") ?: 4
                            engine.denominator = call.argument<Int>("denominator") ?: 4
                            engine.subdivision = call.argument<Int>("subdivision") ?: 0
                            engine.measureCount = call.argument<Int>("measureCount") ?: 0
                            engine.volume = (call.argument<Double>("volume") ?: 1.0).toFloat()
                            engine.start()
                            result.success(null)
                        } ?: result.error("NOT_INITIALIZED", "AudioEngine not initialized", null)
                    }

                    "stop" -> {
                        audioEngine?.stop()
                        result.success(null)
                    }

                    "updateBpm" -> {
                        val bpm = call.argument<Int>("bpm") ?: 120
                        audioEngine?.bpm = bpm
                        result.success(null)
                    }

                    "updateVolume" -> {
                        val volume = (call.argument<Double>("volume") ?: 1.0).toFloat()
                        audioEngine?.volume = volume
                        result.success(null)
                    }

                    "dispose" -> {
                        audioEngine?.dispose()
                        audioEngine = null
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }

        // ─── EventChannel — beats vers Dart ─────────────────────────
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL)
            .setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            })
    }

    /**
     * Configure les callbacks du moteur audio pour envoyer
     * les événements beat vers Flutter via l'EventChannel.
     */
    private fun setupCallbacks() {
        audioEngine?.onBeat = { beatIndex, measureIndex ->
            mainHandler.post {
                eventSink?.success(
                    mapOf(
                        "type" to "beat",
                        "beatIndex" to beatIndex,
                        "measureIndex" to measureIndex
                    )
                )
            }
        }

        audioEngine?.onBlockFinished = {
            mainHandler.post {
                eventSink?.success(
                    mapOf("type" to "blockFinished")
                )
            }
        }
    }

    override fun onDestroy() {
        audioEngine?.dispose()
        audioEngine = null
        super.onDestroy()
    }
}
