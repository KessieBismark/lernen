import 'package:flutter_tts/flutter_tts.dart';

class Speak {
  final FlutterTts _flutterTts = FlutterTts();

  speak({required String text, required String locale, String? last}) async {
    // Simulate the speaking process
    // await _flutterTts.setSpeechRate(0.5);

    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
  }
}
