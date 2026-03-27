import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:metronome_for_live/core/models/song.dart';
import 'package:metronome_for_live/core/models/block.dart';
import 'package:metronome_for_live/core/audio/tts_service.dart';

final metronomeEngineProvider = Provider<MetronomeEngine>((ref) {
  final engine = MetronomeEngine(ref);
  ref.onDispose(() => engine.dispose());
  return engine;
});

final metronomePlayingProvider = StateProvider<bool>((ref) => false);
// Temps actuel dans la mesure
final metronomeBeatProvider = StateProvider<int>((ref) => 1);
// Sous-temps actuel dans le beat (pour l'UI optionnelle)
final metronomeSubTickProvider = StateProvider<int>((ref) => 1);

// Gère l'effet de flash momentané (ex: 80ms) pour l'UI
final metronomeFlashProvider = StateProvider<bool>((ref) => false);

final metronomeBpmProvider = StateProvider<int>((ref) => 120);
// Nombre de temps forts par mesure (ex: 4 pour un 4/4)
final metronomeSignatureNumeratorProvider = StateProvider<int>((ref) => 4);
final metronomeSignatureDenominatorProvider = StateProvider<int>((ref) => 4);
// Subdivision du beat (1=Noir, 2=Croche, 3=Triolet, 4=Double)
final metronomeSubdivisionProvider = StateProvider<int>((ref) => 1);

// ===== ÉTATS DU SÉQUENCEUR (Chanson complète) =====
final currentSongProvider = StateProvider<Song?>((ref) => null);
final currentBlockIndexProvider = StateProvider<int>((ref) => 0);
final currentMeasureInBlockProvider = StateProvider<int>((ref) => 1);
final metronomeTotalMeasuresProvider = StateProvider<int?>((ref) => null);

class MetronomeEngine {
  final Ref _ref;
  final AudioPlayer _accentPlayer = AudioPlayer();
  final AudioPlayer _normalPlayer = AudioPlayer();
  final AudioPlayer _subPlayer = AudioPlayer();
  
  Timer? _timer;
  int _currentSubdivisionTick = 1;

  MetronomeEngine(this._ref);

  Future<void> init() async {
    await _accentPlayer.setAsset('assets/audio/click_accent.wav');
    await _normalPlayer.setAsset('assets/audio/click_normal.wav');
    await _subPlayer.setAsset('assets/audio/click_sub.wav');
  }

  void setBpm(int bpm) {
    if (bpm >= 40 && bpm <= 320) {
      _ref.read(metronomeBpmProvider.notifier).state = bpm;
      if (_ref.read(metronomePlayingProvider)) {
        _restartTimer();
      }
    }
  }

  final List<DateTime> _taps = [];

  void tapTempo() {
    final now = DateTime.now();
    _taps.add(now);

    // Ne garder que les frappes récentes (moins de 3 secondes)
    _taps.removeWhere((tap) => now.difference(tap).inSeconds > 3);

    if (_taps.length >= 2) {
      // Calculer la moyenne des intervalles
      final intervals = <int>[];
      for (int i = 1; i < _taps.length; i++) {
        intervals.add(_taps[i].difference(_taps[i - 1]).inMilliseconds);
      }
      
      final avgInterval = intervals.reduce((a, b) => a + b) / intervals.length;
      int newBpm = (60000 / avgInterval).round();
      if (newBpm > 320) newBpm = 320;
      if (newBpm < 40) newBpm = 40;
      
      setBpm(newBpm);
    }
  }

  void setSignature(int numerator, int denominator) {
    if (numerator >= 1 && numerator <= 16) {
      _ref.read(metronomeSignatureNumeratorProvider.notifier).state = numerator;
    }
    if ([2, 4, 8, 16].contains(denominator)) {
      _ref.read(metronomeSignatureDenominatorProvider.notifier).state = denominator;
    }
  }

  void setSubdivision(int sub) {
    if (sub >= 1 && sub <= 6) {
      _ref.read(metronomeSubdivisionProvider.notifier).state = sub;
      if (_ref.read(metronomePlayingProvider)) {
        _restartTimer();
      }
    }
  }

  // --- GESTION DU CRESCENDO ---
  bool _isCrescendoActive = false;
  int _crescendoTargetBpm = 200;
  int _crescendoStep = 1;
  int _crescendoIntervalBeats = 1;
  int _beatsSinceLastCrescendo = 0;

  void enableCrescendo({
    required int targetBpm,
    required int step,
    required int intervalBeats,
  }) {
    _isCrescendoActive = true;
    _crescendoTargetBpm = targetBpm;
    _crescendoStep = step;
    _crescendoIntervalBeats = intervalBeats;
    _beatsSinceLastCrescendo = 0;
  }

  void disableCrescendo() {
    _isCrescendoActive = false;
  }

  // --- GESTION DES CHANSONS (Séquenceur temporel) ---
  void loadSong(Song song) {
    _ref.read(currentSongProvider.notifier).state = song;
    if (song.blocks.isNotEmpty) {
      _loadBlock(0);
    }
  }

  void _loadBlock(int index) {
    final song = _ref.read(currentSongProvider);
    if (song == null || index < 0 || index >= song.blocks.length) return;
    
    _ref.read(currentBlockIndexProvider.notifier).state = index;
    final block = song.blocks[index];
    
    setBpm(block.startBpm);
    setSignature(block.signatureNumerator, block.signatureDenominator);

    _ref.read(currentMeasureInBlockProvider.notifier).state = 1;
    if (block.durationType == DurationType.fixedMeasures) {
      _ref.read(metronomeTotalMeasuresProvider.notifier).state = block.fixedMeasuresCount;
    } else {
      _ref.read(metronomeTotalMeasuresProvider.notifier).state = null;
    }

    if (block.ttsEnabled) {
      final tts = _ref.read(ttsServiceProvider);
      if (block.ttsText != null && block.ttsText!.isNotEmpty) {
        tts.speak(block.ttsText!);
      } else {
        tts.speak(block.name);
      }
    }
  }

  void start() {
    if (_ref.read(metronomePlayingProvider)) return;
    _ref.read(metronomePlayingProvider.notifier).state = true;
    _ref.read(metronomeBeatProvider.notifier).state = 1;
    _ref.read(metronomeSubTickProvider.notifier).state = 1;
    _currentSubdivisionTick = 1;
    _playClick(1, 1);
    _restartTimer();
  }

  void stop() {
    _ref.read(metronomePlayingProvider.notifier).state = false;
    _ref.read(metronomeFlashProvider.notifier).state = false;
    _timer?.cancel();
    _ref.read(metronomeBeatProvider.notifier).state = 1;
    _ref.read(metronomeSubTickProvider.notifier).state = 1;
    _currentSubdivisionTick = 1;
  }

  void _restartTimer() {
    _timer?.cancel();
    final bpm = _ref.read(metronomeBpmProvider);
    final subdivision = _ref.read(metronomeSubdivisionProvider);
    
    // On calcule l'intervalle pour 1 "tick" de subdivision
    // Si bpm=60 et sub=2 (croches), alors 120 ticks par minute.
    final intervalMicrosec = (60000000 / (bpm * subdivision)).round();
    _timer = Timer.periodic(Duration(microseconds: intervalMicrosec), (_) => _tick());
  }

  void _tick() {
    final subdivision = _ref.read(metronomeSubdivisionProvider);
    var currentBeat = _ref.read(metronomeBeatProvider);
    
    _currentSubdivisionTick++;
    
    if (_currentSubdivisionTick > subdivision) {
      // On passe au beat suivant
      _currentSubdivisionTick = 1;
      currentBeat++;
      
      final num = _ref.read(metronomeSignatureNumeratorProvider);
      if (currentBeat > num) {
        currentBeat = 1; // On reboucle la mesure
        
        // --- SÉQUENCEUR : Avancer la mesure ou changer de bloc ---
        final song = _ref.read(currentSongProvider);
        if (song != null && song.blocks.isNotEmpty) {
          final blockIdx = _ref.read(currentBlockIndexProvider);
          final block = song.blocks[blockIdx];
          
          if (block.durationType == DurationType.fixedMeasures && block.fixedMeasuresCount != null) {
            int measure = _ref.read(currentMeasureInBlockProvider);
            measure++;
            if (measure > block.fixedMeasuresCount!) {
               // FIN DU BLOC !
               if (blockIdx + 1 < song.blocks.length) {
                 _loadBlock(blockIdx + 1); // Passe au bloc suivant auto (déclenche TTS)
                 return; // on quitte pour ne pas refaire _playClick avec l'ancien tempo
               } else {
                 stop(); // La chanson est finie
                 return;
               }
            } else {
               _ref.read(currentMeasureInBlockProvider.notifier).state = measure;
            }
          } else {
             int measure = _ref.read(currentMeasureInBlockProvider);
             _ref.read(currentMeasureInBlockProvider.notifier).state = measure + 1;
          }
        }
      }
      _ref.read(metronomeBeatProvider.notifier).state = currentBeat;

      // Traitement du Crescendo/Decrescendo
      if (_isCrescendoActive) {
        _beatsSinceLastCrescendo++;
        if (_beatsSinceLastCrescendo >= _crescendoIntervalBeats) {
          _beatsSinceLastCrescendo = 0;
          final currentBpm = _ref.read(metronomeBpmProvider);
          if (currentBpm < _crescendoTargetBpm) {
            setBpm(currentBpm + _crescendoStep);
          } else if (currentBpm > _crescendoTargetBpm) {
            setBpm(currentBpm - _crescendoStep);
          }
          if (_ref.read(metronomeBpmProvider) == _crescendoTargetBpm) {
            _isCrescendoActive = false;
          }
        }
      }
    }
    _ref.read(metronomeSubTickProvider.notifier).state = _currentSubdivisionTick;
    
    // Déclencheur du flash visuel
    _ref.read(metronomeFlashProvider.notifier).state = true;
    Timer(const Duration(milliseconds: 30), () {
      // Retombe très vite (30ms) pour une impulsion nette
      _ref.read(metronomeFlashProvider.notifier).state = false;
    });
    
    _playClick(currentBeat, _currentSubdivisionTick);
  }

  Future<void> _playClick(int beat, int subTick) async {
    try {
      if (subTick > 1) {
        // Clic de subdivision
        await _subPlayer.seek(Duration.zero);
        await _subPlayer.play();
      } else {
        // Clic de beat principal (temps fort ou faible)
        if (beat == 1) {
          await _accentPlayer.seek(Duration.zero);
          await _accentPlayer.play();
        } else {
          await _normalPlayer.seek(Duration.zero);
          await _normalPlayer.play();
        }
      }
    } catch (e) {
      debugPrint("Erreur audio: $e");
    }
  }

  void dispose() {
    _timer?.cancel();
    _accentPlayer.dispose();
    _normalPlayer.dispose();
    _subPlayer.dispose();
  }
}
