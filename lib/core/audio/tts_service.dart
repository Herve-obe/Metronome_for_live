import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    // Voix claire en anglais US (idéal pour "One, Two, Three, Four")
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.6); // Vitesse un peu rapide pour ne pas déborder sur les beats
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    await _flutterTts.stop(); // Coupe toute voix en cours
    await _flutterTts.speak(text);
  }
}
