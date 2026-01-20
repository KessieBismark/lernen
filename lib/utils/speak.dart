import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

import 'package:lernen/utils/helpers.dart';

typedef SpeakProgressCallback = void Function(int activeWordIndex);

class Speak {
  final FlutterTts _flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();
  int person = 1;

  // Monthly character tracking
  int _monthlyCharCount = 0;
  final int _monthlyLimit = 4000000;
  DateTime? _monthStart;
  bool _useGoogleCloud = true;

  // Audio cache
  final Map<String, Uint8List> _audioCache = {};

  // Google Cloud API Key
  String? _apiKey = Utils.ttsKey;

  // Track highlight state
  Timer? _highlightTimer;
  StreamSubscription<Duration>? _positionSubscription;
  SpeakProgressCallback? _currentProgressCallback;
  List<String>? _currentWords;
  Duration? _totalDuration;

  Speak() {
    _monthStart = DateTime.now();
  }

  void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }

  void _checkMonthlyReset() {
    final now = DateTime.now();
    if (_monthStart != null &&
        (now.month != _monthStart!.month || now.year != _monthStart!.year)) {
      _monthlyCharCount = 0;
      _monthStart = now;
      _useGoogleCloud = true;
    }
  }

  bool _canUseGoogleCloud(String text) {
    _checkMonthlyReset();
    if (!_useGoogleCloud || _apiKey == null) return false;
    final charCount = text.length;
    if (_monthlyCharCount + charCount > _monthlyLimit) {
      _useGoogleCloud = false;
      return false;
    }
    return true;
  }

  String _improveGermanPronunciation(String text) {
    return text
        .replaceAll('ä', 'ae')
        .replaceAll('ö', 'oe')
        .replaceAll('ü', 'ue')
        .replaceAll('Ä', 'Ae')
        .replaceAll('Ö', 'Oe')
        .replaceAll('Ü', 'Ue')
        .replaceAll('ß', 'ss');
  }

  String _getCacheKey(String text, String locale, String voiceType) {
    final combined = '$text|$locale|$voiceType';
    return md5.convert(utf8.encode(combined)).toString();
  }

  String _getVoiceName(String locale, String type) {
    if (locale.startsWith('de')) {
      if (type == 'female') return 'de-DE-Neural2-A';
      if (type == 'male') return 'de-DE-Neural2-C';
      return 'de-DE-Standard-A';
    }
    if (locale.startsWith('en')) {
      if (type == 'female') return 'en-US-Neural2-C';
      if (type == 'male') return 'en-US-Neural2-A';
      return 'en-US-Standard-A';
    }
    return 'en-US-Standard-A';
  }

  Future<void> _speakWithGoogleCloud({
    required String text,
    required String locale,
    required String voiceType,
  }) async {
    final cacheKey = _getCacheKey(text, locale, voiceType);

    // Cache hit
    if (_audioCache.containsKey(cacheKey)) {
      final cachedBytes = _audioCache[cacheKey]!;
      await _playBytes(cachedBytes);
      return;
    }

    try {
      final voiceName = _getVoiceName(locale, voiceType);

      final requestBody = {
        "input": {"text": text},
        "voice": {
          "languageCode": locale,
          "name": voiceName,
        },
        "audioConfig": {
          "audioEncoding": "MP3",
          "speakingRate": 1.0,
          "pitch": 0.0,
        }
      };

      final res = await http.post(
        Uri.parse(
            'https://texttospeech.googleapis.com/v1/text:synthesize?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final audioContent = data['audioContent'] as String;
        final audioBytes = base64Decode(audioContent);

        _audioCache[cacheKey] = audioBytes;
        _monthlyCharCount += text.length;

        await _playBytes(audioBytes);
      } else {
        throw Exception("GCP TTS failed: ${res.body}");
      }
    } catch (e) {
      _useGoogleCloud = false;
      await _speakWithDeviceTts(
        text: text,
        locale: locale,
        speechRate: 0.5,
        pitch: 1.0,
      );
    }
  }

  /// Play raw bytes (cross-platform)
  Future<void> _playBytes(Uint8List bytes) async {
    if (Platform.isAndroid) {
      await _audioPlayer.play(BytesSource(bytes));
    } else {
      final dir = await getTemporaryDirectory();
      final file =
          File('${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp3');
      await file.writeAsBytes(bytes);
      await _audioPlayer.play(DeviceFileSource(file.path));
    }
  }

  Future<void> _speakWithDeviceTts({
    required String text,
    required String locale,
    required double speechRate,
    required double pitch,
  }) async {
    try {
      String processedText =
          locale.startsWith('de') ? _improveGermanPronunciation(text) : text;

      await _flutterTts.setLanguage(locale);
      await _flutterTts.setSpeechRate(speechRate);
      await _flutterTts.setPitch(pitch);
      await _flutterTts.speak(processedText);
    } catch (_) {}
  }

  Future<void> speak({
    required String text,
    required String locale,
  }) async {
    if (_canUseGoogleCloud(text)) {
      await _speakWithGoogleCloud(
          text: text, locale: locale, voiceType: 'standard');
    } else {
      await _speakWithDeviceTts(
          text: text, locale: locale, speechRate: 0.5, pitch: 1.0);
    }
  }

  // two alternating voices
  Future<void> speakerOne({
    required String text,
    required String locale,
  }) async =>
      await _speakWithGoogleCloud(
        text: text,
        locale: locale,
        voiceType: 'female',
      );

  Future<void> speakerTwo({
    required String text,
    required String locale,
  }) async =>
      await _speakWithGoogleCloud(
        text: text,
        locale: locale,
        voiceType: 'male',
      );

  Future<void> play({
    required String text,
    required String locale,
  }) async {
    if (person == 1) {
      await speakerOne(text: text, locale: locale);
      person = 2;
    } else {
      await speakerTwo(text: text, locale: locale);
      person = 1;
    }
  }

  Future<void> stop() async {
    _highlightTimer?.cancel();
    _positionSubscription?.cancel();
    _currentProgressCallback = null;
    _currentWords = null;
    _totalDuration = null;
    await _audioPlayer.stop();
    await _flutterTts.stop();
  }

  int getRemainingQuota() {
    _checkMonthlyReset();
    return (_monthlyLimit - _monthlyCharCount).clamp(0, _monthlyLimit);
  }

  void resetQuota() {
    _monthlyCharCount = 0;
    _useGoogleCloud = true;
    _monthStart = DateTime.now();
  }

  void clearCache() => _audioCache.clear();

  int getCacheSize() => _audioCache.length;

  void _setupPositionListener() {
    _positionSubscription?.cancel();

    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      if (_currentWords == null ||
          _totalDuration == null ||
          _currentProgressCallback == null) {
        return;
      }

      final words = _currentWords!;
      final totalDuration = _totalDuration!;

      // Calculate time per word based on total duration
      final timePerWord = totalDuration.inMilliseconds / words.length;

      // Determine which word is currently being spoken
      final currentWordIndex = (position.inMilliseconds / timePerWord).floor();

      // Clamp to valid range
      final clampedIndex = currentWordIndex.clamp(0, words.length - 1);

      _currentProgressCallback!(clampedIndex);
    });
  }

  Future<void> speakWithHighlight({
    required String text,
    required String locale,
    SpeakProgressCallback? onProgress,
  }) async {
    // Clean up any existing listeners
    await stop();

    final words = text.split(RegExp(r"\s+"));

    // Store state for position listener
    _currentWords = words;
    _currentProgressCallback = onProgress;

    // Setup position listener before speaking
    _setupPositionListener();

    // Speak the text
    await speak(text: text, locale: locale);

    // Get total duration after audio starts playing
    await Future.delayed(Duration(milliseconds: 500));

    final duration = await _audioPlayer.getDuration();
    if (duration != null) {
      _totalDuration = duration;
    } else {
      // Fallback to estimate if duration unavailable
      _totalDuration = Duration(milliseconds: words.length * 400);
    }

    // Listen for playback completion
    _audioPlayer.onPlayerComplete.listen((_) {
      onProgress?.call(-1);
      _positionSubscription?.cancel();
    });
  }
}
