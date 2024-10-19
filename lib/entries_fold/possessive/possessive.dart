import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/dropdown.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import 'list.dart';
import 'provider.dart';

class Possessive extends StatelessWidget {
  const Possessive({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PoProvider>(
      builder: (BuildContext context, PoProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            value.initialize();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Verbs"),
              actions: [
                IconButton(
                  onPressed: () {
                    Get.to(() => const PossessiveList());
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
                      controller: value.nomController,
                      onChange: (val) => value.nomController.text = val!,
                      list: value.nomList),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: value.germanController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Verb',
                    ),
                  ),
                ),
                value.isSave
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            value.saveVerb();
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
