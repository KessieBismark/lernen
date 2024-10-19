import 'package:flutter/material.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import 'provider.dart';

class GrammerList extends StatelessWidget {
  const GrammerList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GrammerProvider>(context);

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
        body: Consumer<GrammerProvider>(
          builder: (context, provider, child) {
            return provider.wordLoad
                ? const MWaiting()
                : ListView.builder(
                    itemCount: provider.filteredList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: SelectableText(
                              "DE: ${provider.filteredList[index].du}"),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SelectableText(
                                  "ENG: ${provider.filteredList[index].eng}"),
                              Text("Nom: ${provider.filteredList[index].nom!}"),
                              Text(
                                  "Type: ${provider.filteredList[index].caseData!}")
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
