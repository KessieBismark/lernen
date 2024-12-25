import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../utils/ai_dropdown.dart';
import '../../utils/shared_pref.dart';
import '../../utils/waiting.dart';
import 'package:html2md/html2md.dart' as html2md;
import '../chat_area.dart';
import '../provider.dart';

class PreviousChat extends StatelessWidget {
  final String title;
  final dynamic memory;
  final String? sessionID;
  const PreviousChat(
      {super.key, required this.title, this.memory, this.sessionID});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                value.fetchPreviousChat();
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              title,
              style: TextStyle(overflow: TextOverflow.clip),
            ),
            actions: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 3,
                height: 100,
                child: AIDropDown(
                  callBack: (String? newValue) async {
                    await SharedPreferencesUtil.saveString(
                        'ai_model', newValue!);
                  },
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: [
                  value.load
                      ? Expanded(
                          child: ListView(
                            controller: value.previousScrollController,
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
                            controller: value.previousScrollController,
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
                    child: bottomWidgets(
                        controller: value,
                        memory: memory,
                        sessionID: sessionID),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Container bottomWidgets(
      {required ChatProvider controller,
      required dynamic memory,
      String? sessionID}) {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
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
              ? const MWaitingNoCenter()
              : SizedBox(
                  width: 30,
                  height: 30,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (controller.messageController.text.isNotEmpty) {
                        controller.fetchResult(
                            sessionID: sessionID, memory: memory, isNew: false);
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
