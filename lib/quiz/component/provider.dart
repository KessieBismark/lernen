import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lernen/quiz/model.dart';

import '../../ai_logic/groq.dart';
import '../../server.dart';
import '../../utils/app_config.dart';
import '../../utils/helpers.dart';

class QuizProvider extends ChangeNotifier {
  List<QuizModel> quizes = <QuizModel>[];
  bool load = false;
  int currentQuestionIndex = 0;
  bool isAnswered = false;
  QuizModel? currentQuestion;
  bool isCorrect = false;
  bool setResult = false;
  bool isSelected = false;
  String? selectedAnswer;
  int score = 0;
  String selectedLevel = 'Beginner A1';
  List<String> level = [
    'Beginner A1',
    'Elementary A2',
    'Integration B1'
        'Intermediate B2',
    'Advanced C1',
    'Proficient C2'
  ];

  void setSelected(String? value) {
    selectedLevel = value!;
    notifyListeners();
    getQuizes();
  }

  QuizProvider() {
    fetchModel().then((List<ModelInfo> models) async {
      await ConfigStorage.loadFromStorage();

      // Attempt to fetch remote config
      await ConfigService.fetchAndUpdateConfig(Utils.keysUrl);
      Utils.aiListModels = models;
      Utils.selectedAIModel = AppConfig.aiChatModel;
      Utils().setDevideID();
    }).catchError((error) {
      debugPrint('Error in DataProvider: $error');
    });
    getQuizes();
  }

  void checkAnswer(String selected) {
    setResult = true;
    notifyListeners();

    if (selected.trim() == (currentQuestion!.correctAnswer).trim()) {
      isCorrect = true;
      score += 1;
    } else {
      isCorrect = false;
    }
    selectedAnswer = selected;
    isSelected = true;
    setResult = false;
    isAnswered = true;
    notifyListeners();
  }

  Future<List<ModelInfo>> fetchModel() async {
    var record = <ModelInfo>[];
    try {
      final records = await Query.getData(endPoint: "model/model-list/");
      // Fetching the data
      final jsonResponse = jsonDecode(records);
      // Deserialize into ModelListResponse
      final List<dynamic> data = jsonResponse['data'];

      for (var item in data) {
        record
            .add(ModelInfo.fromJson(item)); // Assuming AIModel.fromJson exists
      }

      return record;
    } catch (e) {
      print.call('Error fetching data: $e');
      return record;
    }
  }

  void getQuizes() {
    load = true;
    notifyListeners();
    fetchQuiz().then((value) {
      quizes.addAll(value);
      if (quizes.isEmpty) {
        load = false;
        notifyListeners();
        return;
      }
      currentQuestionIndex = 0;
      currentQuestion = quizes[currentQuestionIndex];
      load = false;
      notifyListeners();
    });
  }

  void submitAnswer() {
    isAnswered = true;
  }

  void nextQuestion() {
    load = true;
    notifyListeners();
    if (currentQuestionIndex < quizes.length) {
      currentQuestionIndex += 1;
      currentQuestion = quizes[(currentQuestionIndex)];
      selectedAnswer = "";
      isCorrect = false;
      isSelected = false;
      isAnswered = false;
      load = false;
      notifyListeners();
    }
    if ((currentQuestionIndex + 2) >= quizes.length) {
      fetchQuiz().then((value) {
        quizes.addAll(value);
      });
    }
  }

  // Future<List<QuizModel>> fetchQuiz() async {
  //   try {
  //     final groq = GroqClient(apiKey: Utils.groqAPI);
  //     final Map<String, dynamic> response =
  //         await groq.getGermanQuiz(selectedLevel);

  //     // Extract questions array from response
  //     final List<dynamic> questions =
  //         response['questions'] as List<dynamic>? ?? [];

  //     // Map each item to QuizModel
  //     return questions
  //         .whereType<Map<String, dynamic>>()
  //         .map((item) => QuizModel.fromJson(item))
  //         .toList();
  //   } catch (e) {
  //     print('Error fetching data: $e');
  //     return [];
  //   }
  // }

  Future<List<QuizModel>> fetchQuiz() async {
    try {
      final groq = GroqClient(apiKey: Utils.groqAPI);
      final dynamic response = await groq.getGermanQuiz(selectedLevel);
      print(response);
      return _parseQuizResponse(response);
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }



  List<QuizModel> _parseQuizResponse(dynamic response) {
    final records = <QuizModel>[];

    if (response == null) return records;

    // Case 1: Already a List<QuizModel> or List<Map>
    if (response is List) {
      for (var item in response) {
        _addQuizItem(item, records);
      }
      return records;
    }

    // Case 2: JSON Map with possible nested structure
    if (response is Map<String, dynamic>) {
      // Try to find quiz data in various possible locations
      _extractFromMap(response, records);
      return records;
    }

    // Case 3: String that might contain JSON
    if (response is String) {
      _parseFromString(response, records);
      return records;
    }

    // Case 4: Try direct conversion for any other type
    try {
      _addQuizItem(response, records);
    } catch (e) {
      print('Failed to parse response of type ${response.runtimeType}: $e');
    }

    return records;
  }

  void _addQuizItem(dynamic item, List<QuizModel> records) {
    try {
      if (item is QuizModel) {
        records.add(item);
      } else if (item is Map<String, dynamic>) {
        // Handle different JSON field naming conventions
        final Map<String, dynamic> processedItem = _normalizeQuizItem(item);
        records.add(QuizModel.fromJson(processedItem));
      } else if (item is Map) {
        // For non-typed Map (from jsonDecode)
        final Map<String, dynamic> typedItem = Map<String, dynamic>.from(item);
        final Map<String, dynamic> processedItem =
            _normalizeQuizItem(typedItem);
        records.add(QuizModel.fromJson(processedItem));
      }
    } catch (e) {
      print('Error adding quiz item: $e\nItem: $item');
    }
  }

  void _extractFromMap(Map<String, dynamic> map, List<QuizModel> records) {
    // Try various possible keys that might contain quiz data
    const List<String> possibleKeys = [
      'questions',
      'data',
      'quiz',
      'items',
      'results',
      'content',
      'message',
      'response'
    ];

    // First, check for direct quiz data in common keys
    for (final key in possibleKeys) {
      if (map.containsKey(key)) {
        final dynamic value = map[key];
        if (value is List) {
          for (var item in value) {
            _addQuizItem(item, records);
          }
          return; // Found and processed
        } else if (value is Map<String, dynamic>) {
          // Recursively extract from nested map
          _extractFromMap(value, records);
        }
      }
    }

    // If no standard keys found, check if map itself looks like a quiz item
    if (_looksLikeQuizItem(map)) {
      _addQuizItem(map, records);
    }

    // Try to extract from all values recursively
    for (final value in map.values) {
      if (value is List) {
        for (var item in value) {
          if (_looksLikeQuizItem(item)) {
            _addQuizItem(item, records);
          }
        }
      } else if (value is Map<String, dynamic>) {
        _extractFromMap(value, records);
      }
    }
  }

  void _parseFromString(String text, List<QuizModel> records) {
    try {
      // Clean markdown code blocks before parsing
      text = text
          .replaceAll(RegExp(r'^```json\s*'), '')
          .replaceAll(RegExp(r'^```\s*'), '')
          .replaceAll(RegExp(r'\s*```$'), '')
          .trim();

      // Try to parse as JSON
      final dynamic parsed = jsonDecode(text);
      records.addAll(_parseQuizResponse(parsed));
    } catch (e) {
      // If not JSON, try to extract JSON-like structures
      _extractJsonFromText(text, records);
    }
  }

  void _extractJsonFromText(String text, List<QuizModel> records) {
    // Look for JSON arrays or objects in the text
    final jsonPattern = RegExp(
        r'(\[\s*\{.*?\}\s*\])|(\{\s*".*?"\s*:\s*\[.*?\]\s*\})',
        dotAll: true);
    final matches = jsonPattern.allMatches(text);

    for (final match in matches) {
      try {
        final dynamic parsed = jsonDecode(match.group(0)!);
        records.addAll(_parseQuizResponse(parsed));
      } catch (e) {
        // Skip invalid JSON
      }
    }
  }

  Map<String, dynamic> _normalizeQuizItem(Map<String, dynamic> item) {
    final Map<String, dynamic> normalized = {};

    // Handle different field name variations
    const fieldMappings = {
      'question': ['question', 'q', 'text', 'prompt'],
      'english_translation': [
        'english_translation',
        'translation',
        'english',
        'answer_english',
        'eng'
      ],
      'options': ['options', 'choices', 'answers', 'alternatives'],
      'correct_answer': [
        'correct_answer',
        'correct',
        'answer',
        'solution',
        'right_answer'
      ],
      'english_explanation': [
        'english_explanation',
        'explanation',
        'reason',
        'rationale',
        'details'
      ]
    };

    for (final targetField in fieldMappings.keys) {
      final possibleSources = fieldMappings[targetField]!;
      for (final source in possibleSources) {
        if (item.containsKey(source)) {
          // Special handling for options list
          if (targetField == 'options') {
            final dynamic value = item[source];
            if (value is List) {
              normalized[targetField] = value.map((e) => e.toString()).toList();
            } else if (value is String) {
              // Try to split string into list
              normalized[targetField] =
                  value.split(',').map((e) => e.trim()).toList();
            }
          } else {
            normalized[targetField] = item[source];
          }
          break;
        }
      }
    }

    return normalized;
  }

  bool _looksLikeQuizItem(dynamic item) {
    if (item is! Map) return false;

    final Map map = item is Map<String, dynamic> ? item : Map.from(item);

    // Check for required fields
    final hasQuestion = map.keys.any((key) => ['question', 'q', 'text']
        .any((qKey) => key.toString().toLowerCase().contains(qKey)));

    final hasOptions = map.keys.any((key) => ['options', 'choices', 'answers']
        .any((optKey) => key.toString().toLowerCase().contains(optKey)));

    return hasQuestion && hasOptions;
  }
}
