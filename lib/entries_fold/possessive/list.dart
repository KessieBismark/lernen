import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class PossessiveList extends StatelessWidget {
  const PossessiveList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PoProvider>(context);

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
        body: Consumer<PoProvider>(
          builder: (context, provider, child) {
            return ListView.builder(
              itemCount: provider.filteredList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: SelectableText(
                        "Verb: ${provider.filteredList[index].vocabs?.du!.capitalize} (${provider.filteredList[index].vocabs?.eng!.capitalize})"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${provider.filteredList[index].tense!} Tense",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SelectableText(
                            "Deutsch: ${provider.filteredList[index].word!}"),
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
