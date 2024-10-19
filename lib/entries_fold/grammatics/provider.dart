import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../server.dart';
import '../models/models.dart';

class GrammerProvider extends ChangeNotifier {
  final TextEditingController germanController = TextEditingController();
  final TextEditingController caseController = TextEditingController();

  final TextEditingController nomController = TextEditingController();
  final TextEditingController engController = TextEditingController();
  List<GrammerModel> gList = <GrammerModel>[];
  List<GrammerModel> gl = <GrammerModel>[];
  List<String> cases = [];

  bool dictLoad = false;
  bool wordLoad = false;
  bool isSave = false;

  clearfields() {
    germanController.clear();
    nomController.clear();
    engController.clear();
  }

  List<GrammerModel> _filteredList = [];

  GrammerProvider() {
    // _filteredList = [];
    _filteredList = gl; // Initially, show all data

    getData();
    notifyListeners(); // Notify listeners to update UI
  }

  List<GrammerModel> get filteredList => _filteredList;

  void search(String query) {
    if (query.isEmpty) {
      _filteredList = gl;
    } else {
      _filteredList = gl
          .where((element) =>
              element.du.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  getData() {
    wordLoad = true;
    notifyListeners();
    fetchGrammatic().then((onValue) {
      gl = [];
      gList = [];
      gl.addAll(onValue);

      gList = gl;
      _filteredList = gl;
      wordLoad = false;
      notifyListeners();
      getNom();
    });
  }

  getNom() {
    wordLoad = true;
    notifyListeners();
//    fetchNominal().then((onValue) {
    // gl = [];
    // gList = [];
    // cases = [];
    // gl.addAll(onValue);
    cases.clear();
    cases.add(" ");
    for (int i = 0; i < gl.length; i++) {
      if (gl[i].nom!.isEmpty) {
        cases.add(gl[i].du.capitalize!);
      }
    }

    // gList = gl;
    wordLoad = false;
    notifyListeners();
    //  });
  }

  void saveGrammer() async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "de": germanController.text.trim(),
        "en": engController.text.trim(),
        "nominative": nomController.text.trim(),
        "case": caseController.text.trim()
      };
      final record =
          await url.collection('grammatical_items').create(body: body);
      debugPrint(record.toString());
      if (record.collectionId.isNotEmpty) {
        clearfields();
        getData();
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

  void updateGrammer(String id) async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "de": germanController.text.trim(),
        "en": engController.text.trim(),
        "nominative": nomController.text.trim(),
        "case": caseController.text.trim()
      };
      final record =
          await url.collection('grammatical_items').update(id, body: body);
      debugPrint(record.toString());
      if (record.collectionId.isNotEmpty) {
        clearfields();
        getData();
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
      await url.collection('grammatical_items').delete(id);
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

  Future<List<GrammerModel>> fetchGrammatic() async {
    wordLoad = true;
    notifyListeners();

    var record = <GrammerModel>[];
    try {
      final records = await url.collection('grammatical_items').getFullList();

      for (var item in records) {
        record.add(GrammerModel.fromJson(item.toJson()));
      }

      wordLoad = false;
      notifyListeners();
      return record;
    } catch (e) {
      wordLoad = false;
      notifyListeners();
      print('Error fetching data: $e');
      return record;
    }
  }

  Future<List<GrammerModel>> fetchNominal() async {
    wordLoad = true;
    notifyListeners();

    var record = <GrammerModel>[];
    try {
      final records = await url
          .collection('grammatical_items')
          .getFullList(filter: 'nominative = NULL');

      for (var item in records) {
        record.add(GrammerModel.fromJson(item.toJson()));
      }

      wordLoad = false;
      notifyListeners();
      return record;
    } catch (e) {
      wordLoad = false;
      notifyListeners();
      print('Error fetching data: $e');
      return record;
    }
  }
}
