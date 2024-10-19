import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/main.dart';
import 'package:lernen/utils/speak.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';

import '../utils/topbar.dart';
import 'provider.dart';

class Verb extends StatelessWidget {
  const Verb({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VerbProvider>(
        builder: (BuildContext context, VerbProvider value, Widget? child) {
      return RefreshIndicator(
        onRefresh: () async {
          await value.getWord();
        },
        child: Scaffold(
          body: SafeArea(
              child: Column(
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
              value.load ? MWaiting() : listData(context, value.cl),
              const Divider(
                indent: 20,
                endIndent: 20,
                color: Colors.blue,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      value.wordShower();
                    },
                    child: const Text("Continue")),
              )
            ],
          )),
        ),
      );
    });
  }

  listData(context, data) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text("* ${data[index].word}"),
                IconButton(
                    onPressed: () {
                      Speak().speak(text: data[index].word, locale: "de-DE");
                    },
                    icon: Icon(Icons.record_voice_over))
              ],
            ),
          );
        });
  }
}
