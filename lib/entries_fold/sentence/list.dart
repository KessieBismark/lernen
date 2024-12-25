import 'package:flutter/material.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import '../../utils/speak.dart';
import 'conversation.dart';
import 'provider.dart';
import 'package:get/get.dart';

class SentenceList extends StatelessWidget {
  const SentenceList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ConProvider>(context);

    return RefreshIndicator(
      onRefresh: () async {
        provider.getData();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
            ),
            onChanged: (query) {
              provider.search(query); // Call search function
            },
          ),
        ),
        body: Consumer<ConProvider>(
          builder: (context, provider, child) {
            return provider.wordLoad
                ? const MWaiting()
                : ListView.builder(
                    itemCount: provider.filteredList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      provider.germanController.text =
                                          provider.filteredList[index].du!;
                                      provider.engController.text =
                                          provider.filteredList[index].eng!;

                                      provider.stController.text =
                                          provider.filteredList[index].stype!;

                                      provider.engController.text =
                                          provider.filteredList[index].eng!;
                                      provider.idController.text =
                                          provider.filteredList[index].id;
                                      provider.caseController.text =
                                          provider.filteredList[index].gcase!;
                                      provider.caseController.text =
                                          provider.filteredList[index].id;
                                      provider.isedit = true;
                                      Get.to(() => Conversation());
                                    },
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      provider.deleteWord(
                                          provider.filteredList[index].id);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ))
                              ],
                            ),
                          ),
                          title: Row(
                            children: [
                              SelectableText(
                                  "DE: ${provider.filteredList[index].vocab!.du!.capitalize}"),
                              IconButton(
                                  onPressed: () {
                                    Speak().speak(
                                        text: provider
                                            .filteredList[index].vocab!.du!,
                                        locale: "de-DE");
                                  },
                                  icon: const Icon(Icons.record_voice_over))
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                  "ENG: ${provider.filteredList[index].vocab!.eng!.capitalize}"),
                              Row(
                                children: [
                                  SelectableText(
                                      "Feminine: ${provider.filteredList[index].vocab!.fe!.capitalize}"),
                                  IconButton(
                                      onPressed: () {
                                        Speak().speak(
                                            text: provider
                                                .filteredList[index].vocab!.fe!,
                                            locale: "de-DE");
                                      },
                                      icon: const Icon(Icons.record_voice_over))
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                    "Case: ${provider.filteredList[index].gcase!.capitalize}"),
                              ),
                              Text(
                                  "Type: ${provider.filteredList[index].stype!.capitalize}"),
                              Divider(),
                              Text(
                                "Example:",
                                style: TextStyle(color: Colors.red),
                              ),
                              Row(
                                children: [
                                  SelectableText(
                                      "* ${provider.filteredList[index].du!.capitalizeFirst} (DE)"),
                                  IconButton(
                                      onPressed: () {
                                        Speak().speak(
                                            text: provider
                                                .filteredList[index].du!,
                                            locale: "de-DE");
                                      },
                                      icon: const Icon(Icons.record_voice_over))
                                ],
                              ),
                              Row(
                                children: [
                                  SelectableText(
                                      "* ${provider.filteredList[index].eng!.capitalizeFirst} (EN)"),
                                  IconButton(
                                      onPressed: () {
                                        Speak().speak(
                                            text: provider
                                                .filteredList[index].eng!,
                                            locale: "en-US");
                                      },
                                      icon: const Icon(Icons.record_voice_over))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
