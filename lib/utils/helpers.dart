import 'dart:math';
import 'package:intl/intl.dart';
import 'shared_pref.dart';

class Utils {
  static String selectedAIModel = "";

  static List<ModelInfo> aiListModels = [];
  static String? deviceID;

  static String formatDateTime(String dateTime) {
    final DateTime date = DateTime.parse(dateTime);
    return DateFormat('MMM d, yyyy • hh:mm a').format(date);
  }

  setDevideID() async {
    final String id = await SharedPreferencesUtil.getString('device_id') ?? "";
    if (id.isEmpty) {
      Utils.deviceID = generateRandom6Numbers().join();
      await SharedPreferencesUtil.saveString("device_id", Utils.deviceID!);
    } else {
      Utils.deviceID = await SharedPreferencesUtil.getString('device_id');
    }
  }
}

class ModelInfo {
  final String id;
  final int created;
  final String object;
  final String ownedBy;
  final bool active;
  final int contextWindow;
  final dynamic publicApps;

  ModelInfo({
    required this.id,
    required this.created,
    required this.object,
    required this.ownedBy,
    required this.active,
    required this.contextWindow,
    this.publicApps,
  });

  factory ModelInfo.fromJson(Map<String, dynamic> json) {
    return ModelInfo(
      id: json['id'],
      created: json['created'],
      object: json['object'],
      ownedBy: json['owned_by'],
      active: json['active'],
      contextWindow: json['context_window'],
      publicApps: json['public_apps'],
    );
  }
}

class AIModel {
  final List<ModelInfo> data;
  final String object;

  AIModel({
    required this.data,
    required this.object,
  });

  factory AIModel.fromJson(Map<String, dynamic> json) {
    return AIModel(
      data: (json['data'] as List)
          .map((item) => ModelInfo.fromJson(item))
          .toList(),
      object: json['object'],
    );
  }
}

List<int> generateRandom6Numbers() {
  final random = Random();
  final numbers = <int>[];

  while (numbers.length < 6) {
    int randomNumber = random.nextInt(100) + 1;
    if (!numbers.contains(randomNumber)) {
      numbers.add(randomNumber);
    }
  }

  return numbers;
}

String fixEncoding(String text) {
  // Replace common encoding issues
  return text
      .replaceAll('Ã\u009f', 'ß')
      .replaceAll('Ã¤', 'ä')
      .replaceAll('Ã¶', 'ö')
      .replaceAll('Ã¼', 'ü')
      .replaceAll('Ã\u0084', 'Ä')
      .replaceAll('Ã\u0096', 'Ö')
      .replaceAll('Ã\u009c', 'Ü');
}

dynamic cleanJson(dynamic data) {
  print(data);
  if (data is String) {
    return fixEncoding(data);
  } else if (data is Map) {
    return data.map((key, value) => MapEntry(key, cleanJson(value)));
  } else if (data is List) {
    return data.map((e) => cleanJson(e)).toList();
  }
  return data;
}

Map<String, dynamic> parseCustomFormat(dynamic input) {
  // This is a simplified parser - you may need to enhance it for your specific needs
  final result = <String, dynamic>{};

  // Remove any Flutter error messages or warnings
  final cleanInput = input.split('flutter:').first;

  // First, try to extract the main data structure
  final match = RegExp(r'\{(.*)\}').firstMatch(cleanInput);
  if (match == null) return result;

  String content = match.group(1) ?? '';

  // Break down the key-value pairs
  // This is a very simplistic approach - a proper parser would be more complex
  int depth = 0;
  String currentKey = '';
  String buffer = '';

  for (int i = 0; i < content.length; i++) {
    final char = content[i];

    if (char == '{') {
      depth++;
      buffer += char;
    } else if (char == '}') {
      depth--;
      buffer += char;

      if (depth == 0 && currentKey.isNotEmpty) {
        // Process nested object
        result[currentKey.trim()] = parseCustomFormat(buffer);
        currentKey = '';
        buffer = '';
      }
    } else if (char == ':' && depth == 0) {
      currentKey = buffer.trim();
      buffer = '';
    } else if (char == ',' && depth == 0) {
      if (currentKey.isNotEmpty) {
        result[currentKey.trim()] = buffer.trim();
      }
      currentKey = '';
      buffer = '';
    } else {
      buffer += char;
    }
  }

  // Process any remaining pair
  if (currentKey.isNotEmpty) {
    result[currentKey.trim()] = buffer.trim();
  }

  return result;
}
