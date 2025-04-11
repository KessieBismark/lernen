import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/ai_verbs/provider_verb.dart';
import 'package:lernen/utils/topbar.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';

import '../utils/ai_dropdown.dart';
import '../utils/shared_pref.dart';
import 'display_widget.dart';
import 'storage/list_verbs.dart';

class AIVerbAssit extends StatelessWidget {
  const AIVerbAssit({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AIVerbProvider>(
      builder: (BuildContext context, AIVerbProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            await value.getWord();
          },
          child: Scaffold(
            body: SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(
                  FocusNode(),
                ),
                child: Column(
                  children: [
                    TopBar(
                      widget: IconButton(
                          onPressed: () {
                            Get.to(() => VocabsListPage());
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
                        ? Expanded(
                            child: MWaiting(),
                          )
                        : value.retry
                            ? Expanded(
                                child: Center(
                                  child: IconButton(
                                    tooltip: "Retry",
                                    onPressed: () {
                                      value.getData(value.word!.name);
                                    },
                                    icon: Icon(Icons.repeat),
                                  ),
                                ),
                              )
                            : Expanded(
                                // scrollDirection: Axis.vertical,
                                child: value.aiJsonResult.isNotEmpty
                                    ? displayGermanData(
                                        context, value.aiJsonResult)
                                    : Container(),
                              ),
                    const Divider(
                      indent: 20,
                      endIndent: 20,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Padding searchPanel(BuildContext context, AIVerbProvider provider) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: provider.controller,
            decoration: InputDecoration(
              labelText: 'Enter a Word',
              suffixIcon: provider.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        provider.controller.clear();
                      },
                    )
                  : null,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            if (provider.controller.text.isNotEmpty) {
              provider.getData(
                provider.controller.text.trim(),
              );
            } else {
              Get.defaultDialog(
                title: "Error",
                content: Text("Enter a word to search"),
                confirm: ElevatedButton(
                  onPressed: () => Get.back,
                  child: Text("Back"),
                ),
              );
            }
          },
        ),
      ],
    ),
  );
}
