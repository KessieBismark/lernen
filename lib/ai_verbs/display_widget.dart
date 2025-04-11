import 'dart:convert';

import 'package:flutter/material.dart';

import '../utils/speak.dart';

Widget displayGermanData(BuildContext context, dynamic jsonString) {
  final Map<dynamic, dynamic> jsonData =jsonString;

  final Map<String, dynamic>? germanData =jsonData['german_data'];
  final Map<String, dynamic>? dataForms =jsonData['data_forms'];
  final Map<String, dynamic>? exampleSentences = jsonData['example_sentences'];



  return SingleChildScrollView(
    
    padding: EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (germanData != null)
          ...germanData.entries.map((entry) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   "German Word:",
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                Text(
                  "${entry.key.capitalize()}:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                  ),
                ),
                SelectableText(
                  " ${utf8.decode(entry.value.codeUnits)}",
                  style: TextStyle(
                    fontSize: 16,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            );
          }),
        SizedBox(height: 20),
        if (dataForms != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Conjugations:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...dataForms.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      "${entry.key.capitalize()}:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (entry.value is Map<String, dynamic>)
                      ...entry.value.entries.map((subEntry) {
                        return Row(
                          children: [
                            SelectableText(
                                "${subEntry.key}: ${utf8.decode(subEntry.value.codeUnits)}"),
                            IconButton(
                              onPressed: () {
                                Speak().speak(
                                    text:
                                        "${subEntry.key}: ${utf8.decode(subEntry.value.codeUnits)}"
                                            .trim(),
                                    locale: "de-DE");
                              },
                              icon: Icon(Icons.volume_up),
                              tooltip: 'Listen',
                            ),
                          ],
                        );
                      }).toList()
                    else
                      Row(
                        children: [
                          SelectableText(utf8.decode(entry.value.codeUnits)),
                          IconButton(
                            onPressed: () {
                              Speak().speak(
                                  text: utf8.decode(entry.value).trim(),
                                  locale: "de-DE");
                            },
                            icon: Icon(Icons.volume_up),
                            tooltip: 'Listen',
                          ),
                        ],
                      ),
                    SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        if (exampleSentences != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Example Sentences:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ...exampleSentences.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${entry.key.capitalize()}:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    sentenceExample(entry),
                    SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
      ],
    ),
  );
}

Row sentenceExample(MapEntry<String, dynamic> entry) {
  String text = entry.value.toString();
  List<String> parts;

  if (text.contains("(")) {
    parts = text.split("(");
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SelectableText.rich(
            TextSpan(
              children: [
                TextSpan(
                  locale: Locale("de"),
                  text: utf8.decode(parts[0].trim().codeUnits),
                  //style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (parts.length > 1)
                  TextSpan(
                    text: " (${parts[1].trim()}",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Speak().speak(text: parts[0].trim(), locale: "de-DE");
          },
          icon: Icon(Icons.volume_up),
          tooltip: 'Listen',
        ),
      ],
    );
  } else {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SelectableText(utf8.decode(text.codeUnits)),
        ),
        IconButton(
          onPressed: () {
            Speak().speak(text: text.trim(), locale: "de-DE");
          },
          icon: Icon(Icons.volume_up),
          tooltip: 'Listen',
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
  }
}
