import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../utils/ai_dropdown.dart';
import '../utils/database/sqflite.dart';
import '../utils/shared_pref.dart';
import '../utils/topbar.dart';
import '../utils/waiting.dart';
import 'chat_area.dart';
import 'provider.dart';

class ChatConversation extends StatelessWidget {
  const ChatConversation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider value, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: [
                  TopBar(
                    widget: Row(
                      children: [
                        IconButton(
                            tooltip: "Start new chat",
                            onPressed: () {
                              value.setNewChatArea();
                            },
                            icon: Icon(Icons.add_comment)),
                        SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            tooltip: "Previous chat",
                            onPressed: () {
                              // value.fetchChatHistory();
                              value.fetchPreviousChat();
                            },
                            icon: Icon(Icons.storage)),
                      ],
                    ),
                  ),
                  AIDropDown(
                    callBack: (String? newValue) async {
                      await SharedPreferencesUtil.saveString(
                          'ai_model', newValue!);
                    },
                  ),
                  value.load
                      ? Expanded(
                          child: ListView(
                            controller: value.scrollController,
                            children: [
                              for (int i = 0; i < value.chatHistory.length; i++)
                                ChatArea(
                                  controller: value,
                                  conversation: value.chatHistory[i],
                                ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView(
                            controller: value.scrollController,
                            children: [
                              for (int i = 0; i < value.chatHistory.length; i++)
                                ChatArea(
                                  controller: value,
                                  conversation: value.chatHistory[i],
                                ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: bottomWidgets(controller: value),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container bottomWidgets({required ChatProvider controller}) {
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        bottom: 10,
        top: 10,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            // color: lightGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              maxLines: null,
              onSubmitted: (text) {},
              controller: controller.messageController,
              decoration: const InputDecoration(
                  hintText: "Type your message here...",
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          controller.load
              ? const MWaiting()
              : SizedBox(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (controller.messageController.text.isNotEmpty) {
                        if (controller.activeSession.isEmpty) {
                          controller.fetchResult(isNew: true);
                        } else {
                          final session = await DatabaseHelper.instance
                              .getSession(controller.activeSession);
                          if (session != null) {
                            final memory = jsonDecode(session['memory']);
                            controller.fetchResult(
                                sessionID: controller.activeSession,
                                memory: memory,
                                isNew: false);
                          }
                        }
                      } else {
                        Get.defaultDialog(
                            title: "Error",
                            content: Text("Enter a word to search"),
                            confirm: ElevatedButton(
                                onPressed: () => Get.back(),
                                child: Text("Back")));
                      }
                    },
                    backgroundColor: Colors.deepPurple,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
