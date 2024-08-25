import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lernen/models.dart';

import 'provider.dart';

class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final TextEditingController _controller = TextEditingController();
  late Future<Map<String, WordData>> _dataFuture;
  final FlutterTts _flutterTts = FlutterTts();
  Map<String, WordData> _dataMap = {};
  List<String> _filteredKeys = [];
  String _selectedWord = '';

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

  void _speak(String text, String lang) async {
    await _flutterTts.setLanguage(lang);
    await _flutterTts.speak(text);
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
      //_controller.text = _selectedWord; // Update the TextField with the selected word
    });

    // Optionally, update _filteredKeys to reflect the entire list
   // _filteredKeys = _dataMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn German App'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          //FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
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
              const SizedBox(height: 10),
              _filteredKeys.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      itemCount: _filteredKeys.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_filteredKeys[index]),
                          onTap: () {
                            setState(() {
                              _selectedWord = _filteredKeys[index];
                              _filteredKeys =
                                  []; // Clear suggestions after selection
                              _controller
                                  .clear(); // Optionally clear the search field
                            });
                          },
                        );
                      },
                    )
                  : Container(),
              const SizedBox(height: 10),
              if (_selectedWord.isNotEmpty &&
                  _dataMap.containsKey(_selectedWord))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                                _speak(_dataMap[_selectedWord]!.translation,
                                    "de-DE");
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
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
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
                                          _speak(sentence.sentenceDe, "de-DE");
                                        },
                                        icon:
                                            const Icon(Icons.record_voice_over))
                                  ],
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.4,
                                      child: SelectableText(
                                          'English: ${sentence.sentenceEn}',
                                          style: const TextStyle(
                                            fontSize: 15,
                                          )),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          _speak(sentence.sentenceEn, "en-US");
                                        },
                                        icon:
                                            const Icon(Icons.record_voice_over))
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}
