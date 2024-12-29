import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lernen/ai_verbs/model.dart';
import 'package:lernen/server.dart';
import 'package:lernen/utils/dropdown.dart';
import 'package:lernen/utils/helpers.dart';
import '../spelling/model.dart';

class AIVerbProvider extends ChangeNotifier {
  List<VerbModel> cl = <VerbModel>[];
  GermanDataModel? verbResult;
  dynamic aiJsonResult = {};
  DropDownModel? word;
  bool wordLoad = false;
  List<DropDownModel> cases = [];
  List<VocabularyModel> wList = <VocabularyModel>[];
  final random = Random();
  bool load = false;
  bool retry = false;
  String? selectedModelId;
  final TextEditingController controller = TextEditingController();

  AIVerbProvider() {
    getWord();
  }

  wordShower() {
    int randomIndex = random.nextInt(cases.length);
    word = cases[randomIndex];
    getData(word!.name);
  }

  getData(String word) async {
    load = true;
    notifyListeners();

    try {
      final data = await fetchVerb(word);
      retry = false;
      if (data != 'false') {
        aiJsonResult = data ?? {};
      } else {
        retry = true;
      }
    } catch (e, stackTrace) {
      debugPrint('Error in getData: $e\n$stackTrace');
    } finally {
      load = false;
      notifyListeners();
    }
  }

  setSelected(String? value) {
    Utils.selectedAIModel = value!;
    notifyListeners();
  }

  getWord() async {
    wordLoad = true;
    notifyListeners();
    wList = [];
    cases = [];

    await fetchWord().then((value) {
      wList.addAll(value);
      for (int i = 0; i < wList.length; i++) {
        cases.add(
            DropDownModel(id: wList[i].id.toString(), name: "${wList[i].du}"));
      }
      wordShower();
      wordLoad = false;
      notifyListeners();
    });
  }

  Future fetchVerb(String word) async {
    wordLoad = true;
    notifyListeners();

    var params = jsonEncode({"verb": word, "model": Utils.selectedAIModel});
    try {
      final records =
          await Query.queryData(query: params, endPoint: "verb/verb_query/");
      wordLoad = false;
      if (records != 'false') {
        return jsonDecode(records);
      } else {
        return "false";
      }
    } catch (e) {
      wordLoad = false;
      notifyListeners();
      print.call('Error fetching data: $e');
      return null;
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
