import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../server.dart';
import '../models/models.dart';

class UploadProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final TextEditingController germanController = TextEditingController();

  final TextEditingController feminiController = TextEditingController();
  final TextEditingController engController = TextEditingController();

  bool dictLoad = false;
  bool wordLoad = false;
  bool isSave = false;

  List<VocabularyModel> wList = <VocabularyModel>[];
  List<VocabularyModel> wl = <VocabularyModel>[];

  clearfields() {
    controller.clear();
    germanController.clear();
    feminiController.clear();
    engController.clear();
  }

  List<VocabularyModel> _filteredList = [];

  UploadProvider() {
    _filteredList = [];
    _filteredList = wl; // Initially, show all data
    getData();
    notifyListeners();
  }

  List<VocabularyModel> get filteredList => _filteredList;

  void search(String query) {
    if (query.isEmpty) {
      _filteredList = wl;
    } else {
      _filteredList = wl
          .where((element) =>
              element.du!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  getData() {
    wordLoad = true;
    notifyListeners();
    fetchVocabulary().then((onValue) {
      wl = [];
      wList = [];
      wl.addAll(onValue);
      wList = wl;
      _filteredList = wl;
      wordLoad = false;
      notifyListeners();
    });
  }

  void saveWord() async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "du": germanController.text.trim(),
        "en": engController.text.trim(),
        "feminie": feminiController.text.trim(),
      };
      final search = await url.collection('vocabulary').getFullList(
            filter: 'du = "${germanController.text.trim()}"',
          );
      if (search.isNotEmpty) {
        Get.defaultDialog(
            title: "Duplicate", content: Text("Item already in database"));
      } else {
        final record = await url.collection('vocabulary').create(body: body);
        if (record.collectionId.isNotEmpty) {
          clearfields();
          const AlertDialog(
            icon: Icon(Icons.info),
            title: Text("Saved"),
            content: Text("Data saved"),
          );
        }
      }
    } catch (e) {
      print(e);
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.error),
        title: Text("Error"),
        content: Text("Not Savec"),
      );
    }
    isSave = false;
    notifyListeners();
  }

  void updateWord(String id) async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "du": germanController.text.trim(),
        "en": engController.text.trim(),
        "feminie": feminiController.text.trim(),
      };
      final record = await url.collection('vocabulary').update(id, body: body);
      debugPrint(record.toString());
      if (record.collectionId.isNotEmpty) {
        clearfields();
        const AlertDialog(
          icon: Icon(Icons.info),
          title: Text("Saved"),
          content: Text("Data saved"),
        );
      }
    } catch (e) {
      print(e);
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.error),
        title: Text("Error"),
        content: Text("Not Savec"),
      );
    }
    isSave = false;
    notifyListeners();
  }

  void deleteWord(String id) async {
    isSave = true;
    notifyListeners();
    try {
      await url.collection('vocabulary').delete(id);
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.info),
        title: Text("Deleted"),
        content: Text("Data deleted"),
      );
    } catch (e) {
      print(e);
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.error),
        title: Text("Error"),
        content: Text("Not Savec"),
      );
    }
  }

  Future<List<VocabularyModel>> fetchVocabulary() async {
    wordLoad = true;
    notifyListeners();

    var record = <VocabularyModel>[];
    try {
      final records = await url.collection('vocabulary').getFullList();
      print(records);
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
