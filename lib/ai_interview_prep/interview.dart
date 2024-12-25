import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/topbar.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';

import '../utils/ai_dropdown.dart';
import '../utils/shared_pref.dart';
import 'conversation.dart';
import 'provider.dart';
import 'storage_view/list_records.dart';

class AIInterviewAssit extends StatelessWidget {
  const AIInterviewAssit({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AIInterviewProvider>(
      builder:
          (BuildContext context, AIInterviewProvider value, Widget? child) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                TopBar(
                  widget: IconButton(
                      onPressed: () {
                        Get.to(() => WordListPage());
                      },
                      icon: Icon(Icons.storage)),
                ),
                AIDropDown(
                  callBack: (String? newValue) async {
                    value.setSelected(newValue);
                    value.getData(value.word!.name);
                    await SharedPreferencesUtil.saveString(
                        'ai_model', newValue!);
                  },
                ),
                searchPanel(context, value),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.blue,
                ),
                value.load
                    ? Expanded(child: MWaiting())
                    : value.retry
                        ? Expanded(
                            child: Center(
                            child: IconButton(
                                tooltip: "Retry",
                                onPressed: () {
                                  value.getData(value.controller.text);
                                },
                                icon: Icon(Icons.repeat)),
                          ))
                        : Expanded(
                            child: value.aiJsonResult.isNotEmpty
                                ? ConversationScreen(
                                    conversation: value.aiJsonResult)
                                : Container()),
                // value.aiJsonResult.isNotEmpty
                //     ? Align(
                //         alignment: Alignment.centerRight,
                //         child: TextButton(
                //           onPressed: () {},
                //           child: Text("Continue"),
                //         ),
                //       )
                //     : Container(),
                const Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Padding searchPanel(BuildContext context, AIInterviewProvider provider) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: provider.controller,
            decoration: InputDecoration(
              labelText: 'Enter your interview search here',
              suffixIcon: provider.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        provider.controller.clear();
                      },
                    )
                  : null,
            ),
            onChanged: (value) {},
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            provider.getData(provider.controller.text.trim());
          },
        ),
      ],
    ),
  );
}
