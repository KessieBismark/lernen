import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/dropdown.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import 'list.dart';
import 'provider.dart';

class Conversation extends StatelessWidget {
  const Conversation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ConProvider>(
      builder: (BuildContext context, ConProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            value.initialize();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Sentence"),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const SentenceList());
                  },
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            body: ListView(
              children: [
                value.wordLoad
                    ? const MWaiting()
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DropDownText2(
                            hint: "select word",
                            label: "select word",
                            controller: value.wordController,
                            onChange: (val) => value.wordController = val,
                            list: value.cases),
                      ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropDownText(
                      hint: "select Case",
                      label: "select Case",
                      controller: value.caseController,
                      onChange: (val) => value.caseController.text = val!,
                      list: const ['Preposition', 'Accusative', 'Dative']),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropDownText(
                      hint: "select Type",
                      label: "select Type",
                      controller: value.stController,
                      onChange: (val) => value.stController.text = val!,
                      list: const ['Fragen', 'Accusative']),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: value.germanController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Deutsch sentence',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: value.engController,
                    decoration: const InputDecoration(
                      labelText: 'Enter English sentence',
                    ),
                  ),
                ),
                value.isSave
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            value.saveSentnce();
                          },
                          child: const Text("Save"),
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
