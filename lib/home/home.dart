import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lernen/home/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool isLast = false;

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

  // void saveState(index) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt('index', index);
  // }

  // readState() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int index = prefs.getInt('index') ?? 0;

  //   return index;
  // }

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

  // _speak(String text, String lang) async {
  //   await _flutterTts.setLanguage(lang);
  //   await _flutterTts.speak(text);
  // }
  Future<void> _speak(
      {required String text, required String locale, String? last}) async {
    print("Speaking ($locale): $text");
    // Simulate the speaking process
    await _flutterTts.setLanguage(locale);
    await _flutterTts.speak(text);
    await Future.delayed(const Duration(milliseconds: 500)); // Adjust as needed
    speaking = false;
    if (text == last) {
      await stepper();
    }
    // Your actual speak implementation here
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

  void debugDataMap() {
    print("Debugging _dataMap:");
    _dataMap.forEach((key, value) {
      print("Key: $key, Value: $value");
    });
  }

  bool _stopRequested = false; // Flag to stop the process

  void stopReading() {
    _stopRequested = true; // Set the flag to true to stop the loop
    speaking = false; // Indicate that the process is stopped
  }

  // void readAll() async {
  //   _stopRequested = false; // Reset the flag before starting the loop
  //   int maxRead = 3;
  //   int index = await readState();
  //   speaking = true;
  //   print("Current index: $index");
  //   print("Data map size: ${_dataMap.length}");

  //   if (index < 0 || index >= _dataMap.length) {
  //     index = 0;
  //     print("Index out of bounds, resetting to 0");
  //   }

  //   for (int i = index; i < _dataMap.length; i++) {
  //     if (_stopRequested) {
  //       print("Stop requested. Breaking out of the loop.");
  //       break; // Exit the loop if stop is requested
  //     }
  //     _selectedWord = _dataMap.keys.elementAt(i);
  //     WordData? word = _dataMap[_selectedWord];

  //     if (word == null) {
  //       continue; // Skip if word is null
  //     }

  //     setState(() {
  //       _filterSearchResults(_selectedWord);
  //     });

  //     await _speak(_selectedWord, "en-US");
  //     for (int j = 0; j < maxRead; j++) {
  //       if (_stopRequested) {
  //         print("Stop requested. Breaking out of the loop.");
  //         break; // Exit the loop if stop is requested
  //       }
  //       await _speak(word.translation, "de-DE");
  //     }
  //     for (Sentence sentence in word.sentences) {
  //       if (_stopRequested) {
  //         print("Stop requested. Breaking out of the loop.");
  //         break; // Exit the loop if stop is requested
  //       }
  //       await _speak(sentence.sentenceEn, "en-US");
  //       for (int j = 0; j < maxRead; j++) {
  //         await _speak(sentence.sentenceDe, "de-DE");
  //       }
  //       await _speak(sentence.sentenceEn, "en-US");
  //     }

  //     await saveState(i + 1); // Move to the next index
  //     print("State saved, next index: ${i + 1}");

  //     await Future.delayed(const Duration(milliseconds: 500)); // Optional delay
  //   }
  //   speaking = false;

  //   print("Processing complete. Final index: $index");
  // }

  stepper() {
    if (isLast = true && speaking) {
      stopReading();
    } else {
      readAll();
    }
  }

  void readAll() async {
    _stopRequested = false; // Reset the flag before starting the loop
    int maxRead = 3;
    int index = await readState();
    speaking = true;
    isLast = false;

    print("Current index: $index");
    print("Data map size: ${_dataMap.length}");

    if (index < 0 || index >= _dataMap.length) {
      index = 0;
      print("Index out of bounds, resetting to 0");
    }

    for (int i = index; i < _dataMap.length; i++) {
      if (_stopRequested) {
        print("Stop requested. Breaking out of the loop.");
        break; // Exit the loop if stop is requested
      }

      // Select the word from the map
      _selectedWord = _dataMap.keys.elementAt(i);
      WordData? word = _dataMap[_selectedWord];

      if (word == null) {
        continue; // Skip if the word is null
      }

      setState(() {
        _filterSearchResults(_selectedWord);
      });

      // Speak the selected word in English
      await _speak(text: _selectedWord, locale: "en-US");

      // Speak the word's translation in German up to maxRead times
      for (int j = 0; j < maxRead; j++) {
        if (_stopRequested) {
          print("Stop requested. Breaking out of the loop.");
          break; // Exit the loop if stop is requested
        }
        await _speak(text: word.translation, locale: "de-DE");
      }

      // Speak each sentence associated with the word
      for (Sentence sentence in word.sentences) {
        if (_stopRequested) {
          print("Stop requested. Breaking out of the loop.");
          break; // Exit the loop if stop is requested
        }

        // Speak sentence in English, then in German (multiple times)
        await _speak(text: sentence.sentenceEn, locale: "en-US");

        for (int j = 0; j < maxRead; j++) {
          if (_stopRequested) {
            print("Stop requested. Breaking out of the loop.");
            break; // Exit the loop if stop is requested
          }
          await _speak(text: sentence.sentenceDe, locale: "de-DE");
        }

        // Speak the sentence again in English after the German sentence
        await _speak(
            text: sentence.sentenceEn,
            locale: "en-US",
            last: sentence.sentenceEn);
      }

      // Save the state to mark the next index as the current one
      await saveState(i + 1);
      print("State saved, next index: ${i + 1}");
      isLast = true;
      stepper();
      // Optional delay before moving to the next word
      await Future.delayed(const Duration(milliseconds: 500));
    }

    speaking = false;
    print("Processing complete. Final index: $index");
  }

  Future<void> saveState(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('index', index);
  }

  Future<int> readState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('index') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Learn German App'),
      // ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          //FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          child: ListView(
            children: [
              TopBar(),
              SizedBox(
                height: 20,
              ),
              // speaking
              //     ? Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Align(
              //             alignment: Alignment.bottomRight,
              //             child: ElevatedButton(
              //               onPressed: speaking
              //                   ? stopReading
              //                   : null, // Only enable button if speaking is true
              //               child: const Text('Stop'),
              //             )),
              //       )
              //     : Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: Align(
              //             alignment: Alignment.bottomRight,
              //             child: ElevatedButton(
              //               onPressed: () {
              //                 readAll();
              //                 //debugDataMap();
              //               },
              //               child: const Text("Play All"),
              //             )),
              //       ),
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
              _filteredKeys.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
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
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              if (_selectedWord.isNotEmpty &&
                  _dataMap.containsKey(_selectedWord))
                Padding(
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
                                          _speak(
                                              text: sentence.sentenceDe,
                                              locale: "de-DE");
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
                                          _speak(
                                              text: sentence.sentenceEn,
                                              locale: "en-US");
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
