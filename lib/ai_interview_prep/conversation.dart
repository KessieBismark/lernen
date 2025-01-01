import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lernen/ai_interview_prep/model.dart';

import '../utils/speak.dart';

class ConversationScreen extends StatelessWidget {
  final List<ConversationEntry> conversation;

  const ConversationScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      itemCount: conversation.length,
      itemBuilder: (context, index) {
        final message = conversation[index];
        final isAgent = message.speaker != 'Interviewer';

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: isAgent ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAgent ? Colors.white60 : Colors.black45,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    message.speaker,
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
                          utf8.decode(message.german.codeUnits),
                          style: TextStyle(
                            //overflow: TextOverflow.visible,
                            color: isAgent ? Colors.black87 : Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Speak().speak(
                              text: utf8.decode(message.german.codeUnits),
                              locale: "de-DE");
                        },
                        icon: Icon(Icons.volume_up),
                        tooltip: 'Listen',
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    message.english,
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
  }

  // Optional: Method to parse JSON
  static ConversationScreen fromJson(String jsonString) {
    final Map<String, dynamic> data = json.decode(jsonString);
    return ConversationScreen(
      conversation: data['conversation'],
    );
  }
}
