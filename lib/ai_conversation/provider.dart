import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../server.dart';
import '../utils/database/sqflite.dart';
import '../utils/helpers.dart';
import 'storage/conversation_list.dart';

class ChatProvider extends ChangeNotifier {
  final messageController = TextEditingController();
  final ScrollController previousScrollController = ScrollController();

  final ScrollController scrollController = ScrollController();
  dynamic history = {};
  String activeSession = "";
  String title = "";
  dynamic previousChat;

  dynamic chatHistory = {};
  bool load = false;

  void setNewChatArea() {
    activeSession = "";
    chatHistory = {};
    messageController.clear();
    notifyListeners();
  }

  void scrollToLastHumanMessage() {
    if (chatHistory.isEmpty) return;

    final lastHumanIndex =
        chatHistory.lastIndexWhere((message) => message['type'] == "human");

    if (lastHumanIndex != -1 && scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void preScrollToLastHumanMessage() {
    if (chatHistory.isEmpty) return;

    final lastHumanIndex =
        chatHistory.lastIndexWhere((message) => message['type'] == "human");

    if (lastHumanIndex != -1 && previousScrollController.hasClients) {
      previousScrollController.animateTo(
        previousScrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> fetchResult(
      {dynamic memory,
      required bool isNew,
      String? sessionID,
      bool isHistory = false}) async {
    load = true;
    notifyListeners();
    try {
      if (isNew) {
        sessionID = generateRandom6Numbers().join();
        activeSession = sessionID;
      }
      var params = jsonEncode({
        "data": messageController.text.trim(),
        "model": Utils.selectedAIModel,
        "chat_memory": memory
      });
      final records =
          await Query.queryData(query: params, endPoint: "conversation/chat/");
      if (records != 'false' && records != null) {
        final parsedData = jsonDecode(records);
        memory = {};
        memory = parsedData['memory'];
        if (isNew) {
          title = parsedData['title'];
        }
        chatHistory = (parsedData['chat_history']);

        await DatabaseHelper.instance.upsertChatSession(
            sessionId: sessionID!, title: title, memory: jsonEncode(memory));
        messageController.clear();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (isHistory) {
            preScrollToLastHumanMessage();
          } else {
            scrollToLastHumanMessage();
          }
        });
      }
    } catch (e) {
     debugPrint('Error fetching data: $e');
    } finally {
      load = false;
      notifyListeners();
    }
  }

  Future<void> fetchPreviousChat() async {
    load = true;
    notifyListeners();
    try {
      previousChat = await DatabaseHelper.instance.getAllSessions();
      Get.to(() => ChatHistoryList());
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      load = false;
      notifyListeners();
    }
  }
}
