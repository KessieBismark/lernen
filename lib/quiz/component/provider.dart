import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lernen/quiz/model.dart';

import '../../server.dart';
import '../../utils/helpers.dart';
import '../../utils/shared_pref.dart';

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
    'Intermediate B1',
    'Advanced C1',
    'Proficient C2'
  ];

  setSelected(String? value) {
    selectedLevel = value!;
    notifyListeners();
    getQuizes();
  }

  QuizProvider() {
    fetchModel().then((List<ModelInfo> models) async {
      Utils.aiListModels = models;
      Utils.selectedAIModel =
          await SharedPreferencesUtil.getString('ai_model') ?? "";
      Utils().setDevideID();
    }).catchError((error) {
      debugPrint('Error in DataProvider: $error');
    });
    getQuizes();
  }

  checkAnswer(String selected) {
    setResult = true;
    notifyListeners();

    if (selected.trim() ==
        utf8.decode((currentQuestion!.correctAnswer).trim().codeUnits)) {
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

  getQuizes() {
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

  Future<List<QuizModel>> fetchQuiz() async {
    var record = <QuizModel>[];
    try {
      var params =
          jsonEncode({"model": Utils.selectedAIModel, "level": selectedLevel});

      final records =
          await Query.queryData(query: params, endPoint: "quiz/quiz/");
      var data = jsonDecode(records);
      if (data == null) {
        return [];
      }
      for (var item in data) {
        record.add(QuizModel.fromJson(item));
      }
      return record;
    } catch (e) {
      print.call('Error fetching data: $e');
      return record;
    }
  }
}
