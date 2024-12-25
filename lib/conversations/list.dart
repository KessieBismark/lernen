import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/entries_fold/models/models.dart';
import 'package:lernen/utils/topbar.dart';
import 'package:provider/provider.dart';

import '../utils/speak.dart';
import '../utils/waiting.dart';
import 'provider.dart';

class Convo extends StatelessWidget {
  const Convo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConversationProvider>(builder:
        (BuildContext context, ConversationProvider value, Widget? child) {
      return RefreshIndicator(
        onRefresh: () async {
          await value.getWord();
        },
        child: Scaffold(
          body: SafeArea(
              child: Stack(
            children: [
              Column(
                children: [
                  TopBar(),
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      " ${value.word?.name.capitalize ?? ""}",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.blue,
                  ),
                  const Text(
                    'Examples',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child:
                        value.load ? MWaiting() : listData(context, value.cl),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                    color: Colors.blue,
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                        onPressed: () {
                          value.wordShower();
                        },
                        icon: Icon(Icons.arrow_circle_right,size: 35,)),
                  ))
            ],
          )),
        ),
      );
    });
  }

  listData(context, List<ConModel> dataList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          var data = dataList[index];
          return Column(
            //    shrinkWrap: true,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Type: ${data.stype}")),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: SelectableText(
                      'German: ${data.du}',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.visible),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        Speak().speak(text: data.du!, locale: "de-DE");
                      },
                      icon: const Icon(Icons.record_voice_over))
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: SelectableText('English: ${data.eng}',
                        style: const TextStyle(
                          fontSize: 15,
                        )),
                  ),
                  IconButton(
                    onPressed: () {
                      Speak().speak(text: data.eng!, locale: "en-US");
                    },
                    icon: const Icon(Icons.record_voice_over),
                  )
                ],
              ),
              const SizedBox(height: 5),
              const Divider(
                indent: 20,
                thickness: 0.3,
                endIndent: 20,
                color: Colors.blue,
              ),
            ],
          );
        },
      ),
    );
  }
}
