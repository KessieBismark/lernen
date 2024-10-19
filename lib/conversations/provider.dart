import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lernen/utils/dropdown.dart';

import '../entries_fold/models/models.dart';
import '../server.dart';

class ConversationProvider extends ChangeNotifier {
  bool wordLoad = false;
  List<DropDownModel> cases = [];
  List<ConModel> cl = <ConModel>[];
  DropDownModel? word;
  List<VocabularyModel> wList = <VocabularyModel>[];
  final random = Random();
  bool load = false;

  ConversationProvider() {
    getWord();
  }

  wordShower() {
    // Ensure the random index is within the full data map
    int randomIndex = random.nextInt(cases.length);
    word = cases[randomIndex];
    getData(word!.id);
  }

  getWord() async {
    wordLoad = true;
    notifyListeners();
    wList = [];
    cases = [];

    await fetchWord().then((value) {
      wList.addAll(value);
      for (int i = 0; i < wList.length; i++) {
        cases.add(DropDownModel(
            id: wList[i].id.toString(),
            name: "${wList[i].du} (${wList[i].eng})"));
      }
      wordShower();
      wordLoad = false;
      notifyListeners();
    });
  }

  getData(String id) async {
    load = true;
    notifyListeners();
    await fetchSentence(id).then((onValue) {
      cl = [];
      cl.addAll(onValue);
      load = false;
      notifyListeners();
    });
  }

  Future<List<ConModel>> fetchSentence(String id) async {
    wordLoad = true;
    notifyListeners();

    var record = <ConModel>[];
    try {
      final records = await url
          .collection('sentences')
          .getFullList(filter: 'voc_fk = "$id"');

      for (var item in records) {
        record.add(ConModel.fromJson(item.toJson()));
      }

      wordLoad = false;
      notifyListeners();
      return record;
    } catch (e) {
      wordLoad = false;
      notifyListeners();
      print.call('Error fetching data: $e');
      return record;
    }
  }

  Future<List<VocabularyModel>> fetchWord() async {
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
      print.call('Error fetching data: $e');
      return record;
    }
  }
}
