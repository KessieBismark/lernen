import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models.dart';

class DataProvider {
  static Future<Map<String, WordData>> loadData() async {
    final jsonString = await rootBundle.loadString('assets/dict.json');
    final jsonResponse = json.decode(jsonString);

    final Map<String, dynamic> jsonMap = jsonResponse;
    final Map<String, WordData> dataMap = {};

    jsonMap.forEach((key, value) {
      dataMap[key] = WordData.fromJson(value);
    });

    return dataMap;
  }
}
