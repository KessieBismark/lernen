import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:html2md/html2md.dart' as html2md;
import 'provider.dart';

class ChatArea extends StatelessWidget {
  final dynamic conversation;
  final ChatProvider controller;

  const ChatArea({
    super.key,
    required this.conversation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final message = conversation;

    final isAgent = message['type'] != "human";
    var mData = html2md.convert(message['content']);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: isAgent ? Alignment.centerLeft : Alignment.centerRight,
        child: isAgent
            ? NotificationListener<OverscrollNotification>(
                onNotification: (overscroll) {
                  if (overscroll.metrics.pixels ==
                          overscroll.metrics.maxScrollExtent &&
                      overscroll.overscroll > 0) {
                    return false;
                  } else if (overscroll.metrics.pixels ==
                          overscroll.metrics.maxScrollExtent &&
                      overscroll.overscroll < 0) {
                    return false;
                  }
                  return true;
                },
                child: SizedBox(
                  height: 400,
                  child: Markdown(
                    // shrinkWrap: true,
                    selectable: true,
                    data: utf8.decode(mData.codeUnits),
                  ),
                ))
            : Container(
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
                      "You",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isAgent ? Colors.blue[700] : Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    SelectableText(
                      utf8.decode(message['content'].codeUnits),
                      style: TextStyle(
                        color: isAgent ? Colors.black87 : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );


  }
}
