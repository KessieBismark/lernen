import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lernen/server.dart';
import 'package:lernen/utils/dropdown.dart';
import 'package:lernen/utils/helpers.dart';
import '../spelling/model.dart';
import '../utils/database/sqflite.dart';
import 'model.dart';

class AIInterviewProvider extends ChangeNotifier {
  List<ConversationEntry> aiJsonResult = <ConversationEntry>[];
  DropDownModel? word;
  bool wordLoad = false;
  List<DropDownModel> cases = [];
  List<VocabularyModel> wList = <VocabularyModel>[];
  final random = Random();
  bool load = false;
  bool retry = false;
  String? selectedModelId;
  final TextEditingController controller = TextEditingController();

 

  setSelected(String? value) {
    Utils.selectedAIModel = value!;
    notifyListeners();
  }

  getData(String word) async {
    load = true;
    notifyListeners();
    aiJsonResult = [];
    fetchResult(word).then((value) {
      aiJsonResult.addAll(value);
      load = false;
      notifyListeners();
    });
  }

  Future fetchVerb(String word) async {
    wordLoad = true;
    notifyListeners();

    var params = jsonEncode({"data": word, "model": Utils.selectedAIModel});
    try {
      final records = await Query.queryData(
          query: params, endPoint: "prompt_conversation/interview/");
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

  Future<List<ConversationEntry>> fetchResult(String word) async {
    var record = <ConversationEntry>[];
    try {
      
      var params = jsonEncode({"data": word, "model": Utils.selectedAIModel});

      final records = await Query.queryData(
          query: params, endPoint: "prompt_conversation/interview/");
      if (records != 'false' && records != null) {
        final parsedData = jsonDecode(records);

        if (parsedData.containsKey('conversation')) {
          var data = parsedData['conversation'];

          for (var item in data) {
            record.add(ConversationEntry.fromJson(item));
          }
          await DatabaseHelper.instance.insertConversation(word, record);
        }
      }
      return record;
    } catch (e) {
      print.call('Error fetching data: $e');
      return record;
    }
  }
}
