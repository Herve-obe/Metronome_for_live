import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../audio/audio_engine.dart';

/// État du métronome en lecture.
class MetronomeState {
  final bool isPlaying;
  final int currentBeat;
  final int currentMeasure;
  final int bpm;
  final int numerator;
  final int denominator;

  const MetronomeState({
    this.isPlaying = false,
    this.currentBeat = 0,
    this.currentMeasure = 0,
    this.bpm = 120,
    this.numerator = 4,
    this.denominator = 4,
  });

  MetronomeState copyWith({
    bool? isPlaying,
    int? currentBeat,
    int? currentMeasure,
    int? bpm,
    int? numerator,
    int? denominator,
  }) {
    return MetronomeState(
      isPlaying: isPlaying ?? this.isPlaying,
      currentBeat: currentBeat ?? this.currentBeat,
      currentMeasure: currentMeasure ?? this.currentMeasure,
      bpm: bpm ?? this.bpm,
      numerator: numerator ?? this.numerator,
      denominator: denominator ?? this.denominator,
    );
  }
}

/// Notifier pour contrôler le métronome.
class MetronomeNotifier extends StateNotifier<MetronomeState> {
  final AudioEngine _engine;
  bool _initialized = false;

  MetronomeNotifier(this._engine) : super(const MetronomeState());

  Future<void> _ensureInit() async {
    if (!_initialized) {
      await _engine.init();
      _engine.onBeat = (beatIndex, measureIndex) {
        if (mounted) {
          state = state.copyWith(
            currentBeat: beatIndex,
            currentMeasure: measureIndex,
          );
        }
      };
      _engine.onBlockFinished = () {
        if (mounted) {
          state = state.copyWith(isPlaying: false, currentBeat: 0, currentMeasure: 0);
        }
      };
      _initialized = true;
    }
  }

  /// Démarre ou arrête le métronome.
  Future<void> togglePlayback() async {
    await _ensureInit();
    if (state.isPlaying) {
      await _engine.stop();
      state = state.copyWith(isPlaying: false, currentBeat: 0, currentMeasure: 0);
    } else {
      await _engine.start(
        bpm: state.bpm,
        numerator: state.numerator,
        denominator: state.denominator,
      );
      state = state.copyWith(isPlaying: true);
    }
  }

  /// Met à jour le BPM (en temps réel si en lecture).
  Future<void> setBpm(int bpm) async {
    final clampedBpm = bpm.clamp(20, 300);
    state = state.copyWith(bpm: clampedBpm);
    if (state.isPlaying) {
      await _engine.updateBpm(clampedBpm);
    }
  }

  /// Met à jour la signature rythmique.
  void setTimeSignature(int numerator, int denominator) {
    state = state.copyWith(numerator: numerator, denominator: denominator);
    // Si en lecture, il faudra redémarrer pour appliquer la nouvelle signature
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}

/// Provider global du métronome.
final metronomeProvider =
    StateNotifierProvider<MetronomeNotifier, MetronomeState>((ref) {
  return MetronomeNotifier(AudioEngine.instance);
});
