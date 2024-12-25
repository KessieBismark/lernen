import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/speak.dart';
import 'package:provider/provider.dart';

import '../utils/topbar.dart';
import 'provider.dart';

class Spelling extends StatefulWidget {
  const Spelling({super.key});

  @override
  State<Spelling> createState() => _SpellingState();
}

class _SpellingState extends State<Spelling> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        context.read<SpellProvider>().viewWord = false;
      },
      child: Consumer<SpellProvider>(
          builder: (BuildContext context, SpellProvider value, Widget? child) {
        return Scaffold(
          body: SafeArea(
              child: Column(
            children: [
              TopBar(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Text("Marks: ${value.marks}/${value.wordCounter}"),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Tooltip(
                      message: value.eng,
                      child: IconButton(
                          onPressed: () async {
                            Speak().speak(text: value.word, locale: "de-DE");
                          },
                          icon: Icon(
                            Icons.record_voice_over,
                            size: 50,
                          )),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    IconButton(
                        onPressed: () {
                          value.viewWord = true;
                          value.correct = 2;
                          _showBottomDialog(context);
                        },
                        icon: Icon(
                          Icons.remove_red_eye,
                          size: 50,
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  maxLines: 4,

                  controller: value.wordController,
                  // minLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Hier entragen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              value.isSave
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: value.viewWord
                              ? null
                              : () {
                                  if (value.wordController.text.isEmpty) {
                                    showDialog(
                                        context: context,
                                        builder: (
                                          BuildContext context,
                                        ) {
                                          return Column(
                                            children: [
                                              Text("Bitte schreiben"),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text("Close"))
                                            ],
                                          );
                                        });
                                  } else {
                                    if (value.word.toLowerCase() ==
                                        value.wordController.text
                                            .trim()
                                            .toLowerCase()) {
                                      value.marks += 1;
                                      value.correct = 1;
                                      value.viewWord = true;
                                      FlutterBeep.beep();
                                    } else {
                                      value.correct = 0;
                                      value.viewWord = true;
                                      FlutterBeep.beep(false);
                                    }
                                    value.wordCounter += 1;
                                    _showBottomDialog(context);
                                    // value.viewWord = false;
                                  }
                                },
                          child: const Text("Continue")),
                    )
            ],
          )),
        );
      }),
    );
  }

  void _showBottomDialog(BuildContext context) {
    showModalBottomSheet(
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 150, // Adjust height as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context.read<SpellProvider>().viewWord &&
                      context.read<SpellProvider>().correct == 1
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Center(
                        child: Row(
                          children: [
                            Icon(
                              Icons.check,
                              size: 30,
                              weight: 2,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${context.read<SpellProvider>().word.capitalize} (${context.read<SpellProvider>().eng})",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    )
                  : context.read<SpellProvider>().viewWord &&
                          context.read<SpellProvider>().correct == 0
                      ? Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.dangerous,
                                  size: 30,
                                  weight: 2,
                                  color: Colors.red,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${context.read<SpellProvider>().word.capitalize} (${context.read<SpellProvider>().eng})",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                )
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              "${context.read<SpellProvider>().word.capitalize} (${context.read<SpellProvider>().eng})",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
              ElevatedButton(
                onPressed: () {
                  context.read<SpellProvider>().wordShower();
                  context.read<SpellProvider>().viewWord = false;
                  Navigator.pop(context);
                  setState(() {});
                  context.read<SpellProvider>().wordController.clear();
                },
                child: Text('Next'),
              ),
            ],
          ),
        );
      },
    );
  }
}
