import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'u_provider.dart';
import 'vocabs.dart';

class VocabList extends StatelessWidget {
  const VocabList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UploadProvider>(context);

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
        body: Consumer<UploadProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
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
                                provider.pastController.text =
                                    provider.filteredList[index].past!;
                                provider.engController.text =
                                    provider.filteredList[index].eng!;

                                provider.feminiController.text =
                                    provider.filteredList[index].fe!;

                                provider.germanController.text =
                                    provider.filteredList[index].du!;
                                provider.controller.text =
                                    provider.filteredList[index].id;

                                provider.isedit = true;
                                Get.to(() => Vocabs());
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
                    title: SelectableText(
                        "DE: ${provider.filteredList[index].du!.capitalize}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectableText(
                            "FE: ${provider.filteredList[index].fe!.capitalize!}"),
                        SelectableText(
                            "Past: ${provider.filteredList[index].past!.capitalize!}"),
                        SelectableText(
                            "ENG: ${provider.filteredList[index].eng!.capitalize}"),
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
