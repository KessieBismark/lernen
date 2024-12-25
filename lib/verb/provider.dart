import 'dart:math';

import 'package:flutter/material.dart';

import '../entries_fold/models/models.dart';
import '../server.dart';
import '../utils/dropdown.dart';

class VerbProvider extends ChangeNotifier {
  List<VerbModel> cl = <VerbModel>[];
  DropDownModel? word;
  bool wordLoad = false;
  List<DropDownModel> cases = [];
  List<VocabularyModel> wList = <VocabularyModel>[];
  final random = Random();
  bool load = false;

  VerbProvider() {
    getWord();
  }

  wordShower() {
    // Ensure the random index is within the full data map
    int randomIndex = random.nextInt(cases.length);
    word = cases[randomIndex];
    getData(word!.id);
  }

  getData(String id) async {
    load = true;
    notifyListeners();
    await fetchVerb(id).then((onValue) {
      cl = [];
      cl.addAll(onValue);
      load = false;
      notifyListeners();
    });
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
            name: "${wList[i].du} - ${wList[i].past} (${wList[i].eng})"));
      }
      wordShower();
      wordLoad = false;
      notifyListeners();
    });
  }

  Future<List<VerbModel>> fetchVerb(String id) async {
    wordLoad = true;
    notifyListeners();

    var record = <VerbModel>[];
    try {
      // final records = await url
      //     .collection('verb')
      //     .getFullList(expand: "voc_fk", filter: "voc_fk");
      final records =
          await url.collection('verb').getFullList(filter: 'voc_fk = "$id"');
      for (var item in records) {
        record.add(VerbModel.frmJson(item.toJson()));
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
