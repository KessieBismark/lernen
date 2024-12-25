import 'dart:math';
import 'package:intl/intl.dart';
import 'shared_pref.dart';

class Utils {
  static String selectedAIModel = "llama3-8b-8192";

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
