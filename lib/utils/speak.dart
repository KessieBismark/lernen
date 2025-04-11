import 'package:flutter_tts/flutter_tts.dart';

class Speak {
  final FlutterTts _flutterTts = FlutterTts();
  int person = 1;
  speak({required String text, required String locale, String? last}) async {
    // Simulate the speaking process
    // await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setSpeechRate(0.3);
    await _flutterTts.setPitch(1.5);

    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
  }

  speakerOne(
      {required String text, required String locale, String? last}) async {
    // Simulate the speaking process
    await _flutterTts.setSpeechRate(0.2);
    await _flutterTts.setPitch(0.5);

    await _flutterTts.setVoice({"name": "Karen", "locale": locale});

    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
  }

  speakerTwo(
      {required String text, required String locale, String? last}) async {
    // Simulate the speaking process
    await _flutterTts.setSpeechRate(0.2);
    await _flutterTts.setPitch(0.5);

    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
  }

  play({required String text, required String locale, String? last}) {
    if (person == 1) {
      speakerOne(text: text, locale: locale);
      person = 2;
    } else {
      speakerOne(text: text, locale: locale);
      person = 1;
    }
  }

  stop() {
    _flutterTts.stop();
  }

  //   pausePlay() async {
  //     if(_flutterTts.)
  //   await _flutterTts.pause();
  // }
}
