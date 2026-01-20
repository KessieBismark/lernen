import 'package:flutter/material.dart';
import '../../utils/database/sqflite.dart';
import 'conversation_details.dart';

class WordListPage extends StatefulWidget {
  const WordListPage({super.key});

  @override
  State<WordListPage> createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  List<String> words = [];

  @override
  void initState() {
    super.initState();
    _fetchWords();
  }

  // Fetch all distinct words from the database
  Future<void> _fetchWords() async {
    final db = await DatabaseHelper.instance.database;
    final result =
        await db.rawQuery('SELECT DISTINCT word FROM conversation_table');

    setState(() {
      words = result.map((item) => item['word'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations List'),
      ),
      body: ListView.builder(
        itemCount: words.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(words[index].toUpperCase()),
              onTap: () {
                var conversationData = getConversationData(words[index]);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WordDetailsPage(
                      word: words[index],
                      conversationData: conversationData,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// Retrieve conversation data for the selected word
Future<List<Map<String, dynamic>>> getConversationData(String word) async {
  return await DatabaseHelper.instance.getConversations(word);
}
