import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/helpers.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';

import '../../utils/database/sqflite.dart';
import '../provider.dart';
import 'chat_history_area.dart';

class ChatHistoryList extends StatelessWidget {
  const ChatHistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            value.fetchPreviousChat();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("Chat History"),
            ),
            body: value.load
                ? MWaiting()
                : ListView.builder(
                    itemCount: value.previousChat.length,
                    itemBuilder: (context, index) {
                      final message = value.previousChat[index];
                      final dateString =
                          Utils.formatDateTime(message['updated_at']);
                      return Card(
                        child: ListTile(
                          title: Text(
                            message['title'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(dateString),
                          onTap: () {
                            value.chatHistory = {};
                            value.chatHistory =
                                jsonDecode(message['memory'])['chat_history'];
                            value.title = message['title'];
                            Get.to(
                              () => PreviousChat(
                                title: message['title'],
                                memory: jsonDecode(message['memory']),
                                sessionID: message['session_id'],
                              ),
                            );
                          },
                          trailing: IconButton(
                              onPressed: () async {
                                await DatabaseHelper.instance
                                    .deleteSession(message['session_id']);
                                value.fetchPreviousChat();
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                        ),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
