import 'dart:convert';
import 'package:flutter/material.dart';
import '../../utils/speak.dart';

class WordDetailsPage extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> conversationData;
  final String word;

  const WordDetailsPage(
      {super.key, required this.conversationData, required this.word});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details for: ${word.toUpperCase()}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: conversationData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No conversations available.'));
          }

          final conversations = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final message = conversations[index];
              final isAgent = message['speaker'] != 'Interviewer';
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Align(
                  alignment:
                      isAgent ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isAgent ? Colors.white60 : Colors.black45,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['speaker'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isAgent ? Colors.blue[700] : Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              child: SelectableText(
                                utf8.decode(message['german'].codeUnits),
                                style: TextStyle(
                                  color:
                                      isAgent ? Colors.black87 : Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Speak().speak(
                                    text: utf8
                                        .decode(message['german'].codeUnits),
                                    locale: "de-DE");
                              },
                              icon: Icon(Icons.volume_up),
                              tooltip: 'Listen',
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        SelectableText(
                          message['english'],
                          style: TextStyle(
                            color: isAgent ? Colors.black54 : Colors.white70,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
