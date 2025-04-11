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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ElevatedButton(
                //         onPressed: () async {
                //           final List<ConversationEntry> conversation =
                //               value.aiJsonResult;

                //           if (conversation.isNotEmpty) {
                //             int person = 1;

                //             for (int j = 0; j < value.overAllPay; j++) {
                //               for (int i = 0; i < conversation.length; i++) {
                //                 await Speak().speak(
                //                     text: conversation[i].english,
                //                     locale: "en-US");
                //                 for (int q = 0; q < value.sentencePlay; q++) {
                //                   if (person == 1) {
                //                     await Speak().speakerOne(
                //                         text: conversation[i].german,
                //                         locale: "de-DE");
                //                     person = 2;
                //                   } else {
                //                     await Speak().speakerTwo(
                //                         text: conversation[i].german,
                //                         locale: "de-DE");
                //                     person = 1;
                //                   }
                //                   //   german =
                //                   //       "$german. ${utf8.decode((conversation[i].german).codeUnits)}";
                //                   // }
                //                   // english =
                //                   //     "$english. ${utf8.decode((conversation[i].english).codeUnits)}";
                //                 }
                //               }
                //               // Speak().speak(text: german, locale: "de-DE");
                //             }
                //           }
                //         },
                //         child: Text("Play All")),
                //     ElevatedButton(
                //         onPressed: () {
                //           Speak().stop();
                //         },
                //         child: Text("Stop")),
                //   ],
                // ).padding9,
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
