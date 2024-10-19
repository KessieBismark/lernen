import 'dart:math';

import 'package:flutter/material.dart';

import '../entries_fold/models/models.dart';
import '../server.dart';
import '../utils/speak.dart';

class SpellProvider extends ChangeNotifier {
  bool wordLoad = false;
  bool isSave = false;
  final TextEditingController wordController = TextEditingController();

  List<VocabularyModel> wList = <VocabularyModel>[];
  List<VocabularyModel> wl = <VocabularyModel>[];
  final random = Random();
  String word = "";
  bool viewWord = false;
  int wordCounter = 0;
  int marks = 0;
  int correct = 2;

  SpellProvider() {
    getData();
  }

  wordShower() {
    correct = 2;
    viewWord = false;
    // Ensure the random index is within the full data map
    int randomIndex = random.nextInt(wList.length);
    word = wList[randomIndex].du!;
    Speak().speak(text: word, locale: "de-DE");
    return word;
  }

  checker() {
    if (word.toLowerCase() == wordController.text.toLowerCase()) {
      marks += 1;
      correct = 1;
    } else {
      correct = 0;
    }

    wordCounter += 1;
  }

  getData() {
    wordLoad = true;
    notifyListeners();
    fetchVocabulary().then((onValue) {
      wl = [];
      wList = [];
      wl.addAll(onValue);
      wList = wl;
      wordLoad = false;
      notifyListeners();
      wordShower();
    });
  }

  Future<List<VocabularyModel>> fetchVocabulary() async {
    wordLoad = true;
    notifyListeners();

    var record = <VocabularyModel>[];
    try {
      final records = await url.collection('vocabulary').getFullList();
      for (var item in records) {
        record.add(VocabularyModel.fromJson(item.toJson()));
      }

      wordLoad = false;
      notifyListeners();
      return record;
    } catch (e) {
      wordLoad = false;
      notifyListeners();
      print('Error fetching vocabulary: $e');
      return record;
    }
  }
}
