import 'package:flutter/material.dart';
import 'package:lernen/entries_fold/models/models.dart';
import 'package:lernen/utils/dropdown.dart';
import '../../server.dart';

class ConProvider extends ChangeNotifier {
  final TextEditingController germanController = TextEditingController();
  final TextEditingController stController = TextEditingController();
  final TextEditingController caseController = TextEditingController();
  final TextEditingController engController = TextEditingController();
  List<SentenceModel> cList = <SentenceModel>[];
  List<SentenceModel> cl = <SentenceModel>[];
  List<DropDownModel> cases = [];
  List<VocabularyModel> wList = <VocabularyModel>[];
  DropDownModel? wordController;
  bool dictLoad = false;
  bool wordLoad = false;
  bool isSave = false;

  clearfields() {
    germanController.clear();
    wordController = DropDownModel(id: '', name: '');
    engController.clear();
  }

  List<SentenceModel> _filteredList = [];

  ConProvider() {
    // _filteredList = [];
    // _filteredList = cl; // Initially, show all data
    // wordController = DropDownModel(id: '0', name: ' ');
    // cases.clear();
    // getData();
    // getWord();
    // notifyListeners();
    initialize();
  }

  void initialize() async {
    _filteredList = [];
    _filteredList = cl;

    getData();
    getWord();

    notifyListeners();
  }

  List<SentenceModel> get filteredList => _filteredList;

  void search(String query) {
    if (query.isEmpty) {
      _filteredList = cl;
    } else {
      _filteredList = cl
          .where((element) =>
              element.du!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  getData() async {
    wordLoad = true;
    notifyListeners();
    await fetchSentence().then((onValue) {
      cl = [];
      cList = [];
      cl.addAll(onValue);
      cList = cl;
      _filteredList = cl;
      wordLoad = false;
      notifyListeners();
    });
  }

  getWord() async {
    wordLoad = true;
    notifyListeners();
    wList = [];
    cases = [];

    await fetchWord().then((value) {
      wordController = DropDownModel(id: '0', name: ' ');
      cases.add(DropDownModel(id: '0', name: ' '));
      wList.addAll(value);
      for (int i = 0; i < wList.length; i++) {
        cases.add(DropDownModel(
            id: wList[i].id.toString(), name: wList[i].du.toString()));
      }
      wordLoad = false;
      notifyListeners();
    });
  }

  void saveSentnce() async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "english": engController.text.trim(),
        "deutsch": germanController.text.trim(),
        "voc_fk": wordController!.id,
        "gcase": caseController.text.trim(),
        "s_type": stController.text.trim()
      };
      final record = await url.collection('sentences').create(body: body);
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
        content: Text("Not Saved"),
      );
    }
    isSave = false;
    notifyListeners();
  }

  void updateGrammer(String id) async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "english": engController.text.trim(),
        "deutsch": germanController.text.trim(),
        "voc_fk": wordController!.id,
        "gcase": caseController.text.trim(),
        "s_type": stController.text.trim()
      };
      final record = await url.collection('sentences').update(id, body: body);
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
      await url.collection('sentences').delete(id);
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

  Future<List<SentenceModel>> fetchSentence() async {
    wordLoad = true;
    notifyListeners();

    var record = <SentenceModel>[];
    try {
      final records =
          await url.collection('sentences').getFullList(expand: "voc_fk");
      print(records);

      for (var item in records) {
        record.add(SentenceModel.fromJson(item.toJson()));
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
