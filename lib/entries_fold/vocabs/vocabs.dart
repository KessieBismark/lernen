import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'list.dart';
import 'u_provider.dart';

class Vocabs extends StatelessWidget {
  const Vocabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UploadProvider>(
      builder: (BuildContext context, UploadProvider value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Vocabulary"),
            actions: [
              IconButton(
                  onPressed: () => Get.to(() => const VocabList()),
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
                      labelText: 'Deutsch word',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    controller: value.feminiController,
                    decoration: const InputDecoration(
                      labelText: 'Deutsch Feminie',
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                    controller: value.engController,
                    decoration: const InputDecoration(
                      labelText: 'English',
                    )),
              ),
              value.isSave
                  ? const Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                          onPressed: () {
                            value.saveWord();
                          },
                          child: const Text("Save")),
                    )
            ],
          ),
        );
      },
    );
  }
}
