import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lernen/ai_verbs/storage/vocabs_view.dart';
import '../../utils/database/sqflite.dart';

class VocabsListPage extends StatefulWidget {
  const VocabsListPage({super.key});

  @override
  State<VocabsListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<VocabsListPage> {
  List<Map<String, dynamic>> words = [];

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  // Fetch all distinct words from the database
  Future<void> _fetchWords() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery('SELECT * FROM vocabs');

    setState(() {
      words = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Words List'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(words[index]['word'].toString().toUpperCase()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VocabsView(
                        title: words[index]['word'],
                        germanData: json.decode(words[index]['german_data']),
                        dataForms: json.decode(words[index]['data_forms']),
                        exampleSentences:
                            json.decode(words[index]['example_sentences']),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
