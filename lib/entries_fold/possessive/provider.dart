import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/entries_fold/models/models.dart';
import 'package:lernen/utils/dropdown.dart';
import '../../server.dart';

class PoProvider extends ChangeNotifier {
  final TextEditingController germanController = TextEditingController();
  final TextEditingController stController = TextEditingController();
  final TextEditingController caseController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  List<PossModel> cl = <PossModel>[];
  List<DropDownModel> cases = [];
  List<String> nomList = [];
  List<VocabularyModel> wList = <VocabularyModel>[];
  DropDownModel? wordController;
  bool dictLoad = false;
  bool wordLoad = false;
  bool isSave = false;
  List<GrammerModel> gl = <GrammerModel>[];

  clearfields() {
    germanController.clear();
    wordController = DropDownModel(id: '', name: '');
    nomController.clear();
  }

  List<PossModel> _filteredList = [];

  PoProvider() {
    initialize();
  }

  void initialize() async {
    _filteredList = [];
    _filteredList = cl;

    getData();
    getWord();
    getNom();
    notifyListeners();
  }

  getNom() {
    wordLoad = true;
    notifyListeners();
    fetchNominal().then((onValue) {
      gl = [];
      cases = [];
      gl.addAll(onValue);
      nomList.clear();
      nomList.add(" ");
      for (int i = 0; i < gl.length; i++) {
        if (gl[i].nom!.isEmpty) {
          nomList.add(gl[i].du.capitalize!);
        }
      }
      wordLoad = false;
      notifyListeners();
    });
  }

  List<PossModel> get filteredList => _filteredList;

  void search(String query) {
    if (query.isEmpty) {
      _filteredList = cl;
    } else {
      _filteredList = cl
          .where((element) =>
              element.word!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Notify listeners to update UI
  }

  getData() async {
    wordLoad = true;
    notifyListeners();
    await fetchVerb().then((onValue) {
      cl = [];
      cl.addAll(onValue);
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
    wordController = DropDownModel(id: '0', name: ' ');
    cases.add(DropDownModel(id: '0', name: ' '));
    await fetchWord().then((value) {
      wList.addAll(value);
      for (int i = 0; i < wList.length; i++) {
        cases.add(DropDownModel(
            id: wList[i].id.toString(), name: wList[i].du.toString()));
      }
      wordLoad = false;
      notifyListeners();
    });
  }

  void saveVerb() async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "word": "${nomController.text.trim()} ${germanController.text.trim()}",
        "voc_fk": wordController!.id,
      };
      final record = await url.collection('verb').create(body: body);
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

  void updateVerb(String id) async {
    isSave = true;
    notifyListeners();
    try {
      final body = <String, dynamic>{
        "word": "${nomController.text.trim()} ${germanController.text.trim()}",
        "voc_fk": wordController!.id,
      };
      final record = await url.collection('verb').update(id, body: body);
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
      await url.collection('verb').delete(id);
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.info),
        title: Text("Deleted"),
        content: Text("Data deleted"),
      );
    } catch (e) {
      isSave = false;
      notifyListeners();
      const AlertDialog(
        icon: Icon(Icons.error),
        title: Text("Error"),
        content: Text("Not Savec"),
      );
    }
  }

  Future<List<PossModel>> fetchVerb() async {
    wordLoad = true;
    notifyListeners();

    var record = <PossModel>[];
    try {
      final records =
          await url.collection('verb').getFullList(expand: "voc_fk");
      print(records);
      for (var item in records) {
        record.add(PossModel.frmJson(item.toJson()));
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
