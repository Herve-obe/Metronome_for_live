import 'dart:async';
import 'package:flutter/services.dart';

/// Interface Dart vers le moteur audio natif (Android).
/// Communique via MethodChannel pour les commandes
/// et EventChannel pour les callbacks de beat.
class AudioEngine {
  AudioEngine._();
  static final AudioEngine instance = AudioEngine._();

  static const _methodChannel =
      MethodChannel('com.metronomeforlive/audio_engine');
  static const _eventChannel =
      EventChannel('com.metronomeforlive/audio_engine/beats');

  StreamSubscription? _beatSubscription;
  void Function(int beatIndex, int measureIndex)? onBeat;
  void Function()? onBlockFinished;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  /// Initialise le moteur audio natif.
  Future<void> init() async {
    await _methodChannel.invokeMethod('init');
  }

  /// Démarre le métronome avec les paramètres donnés.
  Future<void> start({
    required int bpm,
    required int numerator,
    required int denominator,
    int subdivision = 0,
    int measureCount = 0,
    double volume = 1.0,
    String accentSound = 'click_accent',
    String normalSound = 'click_normal',
    String subdivisionSound = 'click_sub',
  }) async {
    await _methodChannel.invokeMethod('start', {
      'bpm': bpm,
      'numerator': numerator,
      'denominator': denominator,
      'subdivision': subdivision,
      'measureCount': measureCount,
      'volume': volume,
      'accentSound': accentSound,
      'normalSound': normalSound,
      'subdivisionSound': subdivisionSound,
    });
    _isPlaying = true;
    _listenToBeats();
  }

  /// Arrête le métronome.
  Future<void> stop() async {
    await _methodChannel.invokeMethod('stop');
    _isPlaying = false;
    _beatSubscription?.cancel();
    _beatSubscription = null;
  }

  /// Met à jour le BPM en temps réel (sans redémarrer).
  Future<void> updateBpm(int bpm) async {
    await _methodChannel.invokeMethod('updateBpm', {'bpm': bpm});
  }

  /// Met à jour le volume en temps réel.
  Future<void> updateVolume(double volume) async {
    await _methodChannel.invokeMethod('updateVolume', {'volume': volume});
  }

  /// Libère les ressources natives.
  Future<void> dispose() async {
    await stop();
    await _methodChannel.invokeMethod('dispose');
  }

  void _listenToBeats() {
    _beatSubscription?.cancel();
    _beatSubscription = _eventChannel.receiveBroadcastStream().listen(
      (event) {
        if (event is Map) {
          final type = event['type'] as String?;
          if (type == 'beat') {
            final beatIndex = event['beatIndex'] as int;
            final measureIndex = event['measureIndex'] as int;
            onBeat?.call(beatIndex, measureIndex);
          } else if (type == 'blockFinished') {
            onBlockFinished?.call();
          }
        }
      },
      onError: (error) {
        // Silently handle stream errors
      },
    );
  }
}
