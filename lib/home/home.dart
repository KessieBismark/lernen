import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lernen/home/models.dart';
import '../server.dart';
import '../utils/helpers.dart';
import '../utils/shared_pref.dart';
import '../utils/topbar.dart';
import 'provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _NewHomeState();
}

class _NewHomeState extends State<Home> {
  final TextEditingController _controller = TextEditingController();
  late Future<Map<String, WordData>> _dataFuture;
  final FlutterTts _flutterTts = FlutterTts();
  Map<String, WordData> _dataMap = {};
  List<String> _filteredKeys = [];
  String _selectedWord = '';
  bool speaking = false;
  bool _stopRequested = false;

  @override
  void initState() {
    super.initState();

    _dataFuture = DataProvider.loadData();
    _dataFuture.then((data) {
      setState(() {
        _dataMap = data;
        _filteredKeys = _dataMap.keys.toList();
      });
    });
    fetchModel().then((List<ModelInfo> models) async {
      Utils.aiListModels = models;
      Utils.selectedAIModel =
          await SharedPreferencesUtil.getString('ai_model') ?? "llama3-8b-8192";
      Utils().setDevideID();
    }).catchError((error) {
      print('Error in DataProvider: $error');
    });
    print(Utils.aiListModels.toString());
  }

  Future<List<ModelInfo>> fetchModel() async {
    var record = <ModelInfo>[];
    try {
      final records = await Query.getData(endPoint: "model/model-list/");
      // Fetching the data
      final jsonResponse = jsonDecode(records);
      print(jsonResponse);
      // Deserialize into ModelListResponse
      final List<dynamic> data = jsonResponse['data'];

      for (var item in data) {
        record
            .add(ModelInfo.fromJson(item)); // Assuming AIModel.fromJson exists
      }

      return record;
    } catch (e) {
      print.call('Error fetching data: $e');
      return record;
    }
  }

  void _filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredKeys = _dataMap.keys.toList();
        _selectedWord = ''; // Clear selection if query is empty
      });
    } else {
      setState(() {
        _filteredKeys = _dataMap.keys
            .where((key) => key.toLowerCase().contains(query.toLowerCase()))
            .toList();
        // Clear the selected word if it is no longer in the filtered results
        if (!_filteredKeys.contains(_selectedWord)) {
          _selectedWord = '';
        }
      });
    }
  }

  Future<void> _speak({required String text, required String locale}) async {
    // Simulate the speaking process
    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
  }

  void _shuffleAndPickRandomVerb() {
    if (_dataMap.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No words available in the list')),
      );
      return; // Exit early if no data is available
    }

    final random = Random();

    setState(() {
      // Ensure the random index is within the full data map
      int randomIndex = random.nextInt(_dataMap.length);
      _selectedWord = _dataMap.keys.elementAt(randomIndex);
      _filterSearchResults(_selectedWord);
    });
  }

  void debugDataMap() {
    print("Debugging _dataMap:");
    _dataMap.forEach((key, value) {
      print("Key: $key, Value: $value");
    });
  }

  void stopReading() {
    _stopRequested = true; // Set the flag to true to stop the loop
    speaking = false; // Indicate that the process is stopped
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: ListView(
            children: [
              TopBar(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Enter English Word',
                          suffixIcon: _controller.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _controller.clear();
                                      _filterSearchResults('');
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _filterSearchResults(value);
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shuffle),
                      onPressed: _shuffleAndPickRandomVerb,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _filteredKeys.isNotEmpty ? searchPanel(context) : Container(),
              const SizedBox(height: 10),
              if (_selectedWord.isNotEmpty &&
                  _dataMap.containsKey(_selectedWord))
                searchResult(context),
            ],
          ),
        ),
      ),
    );
  }

  Padding searchPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _filteredKeys.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_filteredKeys[index]),
              onTap: () {
                setState(() {
                  _selectedWord = _filteredKeys[index];
                  _filteredKeys = []; // Clear suggestions after selection
                  _controller.clear(); // Optionally clear the search field
                });
              },
            );
          },
        ),
      ),
    );
  }

  Padding searchResult(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Details for "$_selectedWord"',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Translation: ${_dataMap[_selectedWord]!.translation}',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible),
              ),
              IconButton(
                  onPressed: () {
                    _speak(
                        text: _dataMap[_selectedWord]!.translation,
                        locale: "de-DE");
                  },
                  icon: const Icon(Icons.record_voice_over))
            ],
          ),
          const SizedBox(height: 10),
          const Text('Example sentence:'),
          const Divider(
            indent: 20,
            endIndent: 20,
            color: Colors.blue,
          ),
          ..._dataMap[_selectedWord]!.sentences.map(
                (sentence) => Column(
                  //    shrinkWrap: true,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child: SelectableText(
                            'German: ${sentence.sentenceDe}',
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.visible),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              _speak(
                                  text: sentence.sentenceDe, locale: "de-DE");
                            },
                            icon: const Icon(Icons.record_voice_over))
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.4,
                          child:
                              SelectableText('English: ${sentence.sentenceEn}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                  )),
                        ),
                        IconButton(
                            onPressed: () {
                              _speak(
                                  text: sentence.sentenceEn, locale: "en-US");
                            },
                            icon: const Icon(Icons.record_voice_over))
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.blue,
                    )
                  ],
                ),
              ),
          const SizedBox(height: 20),
          const Center(
              child: Text(
            textAlign: TextAlign.center,
            "Tap on the speaker icon for pronunciation. Not all words are included in the library",
            style: TextStyle(
              color: Colors.green,
            ),
          ))
        ],
      ),
    );
  }
}
