import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/dropdown.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import 'list.dart';
import 'provider.dart';

class Grammatic extends StatelessWidget {
  const Grammatic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<GrammerProvider>(
      builder: (BuildContext context, GrammerProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            value.getData();
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Grammatic Cases"),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const GrammerList());
                    },
                    icon: const Icon(Icons.search))
              ],
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                      controller: value.germanController,
                      decoration: const InputDecoration(
                        labelText: 'Deutsch ',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                      controller: value.engController,
                      decoration: const InputDecoration(
                        labelText: 'English ',
                      )),
                ),
                value.wordLoad
                    ? const MWaiting()
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: DropDownText(
                            hint: "select Nominative",
                            label: "select Nominative",
                            controller: value.nomController,
                            onChange: (val) => value.nomController.text = val!,
                            list: value.cases),
                      ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropDownText(
                    hint: "select Case",
                    label: "select Case",
                    controller: value.caseController,
                    onChange: (val) => value.caseController.text = val!,
                    list: const [
                      'Preposition',
                      'Possesive',
                      'Accusative',
                      'Dative'
                    ],
                  ),
                ),
                value.isSave
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ElevatedButton(
                          onPressed: () {
                            value.saveGrammer();
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
