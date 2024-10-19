import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/entries_fold/grammatics/grammatic.dart';
import 'package:lernen/entries_fold/sentence/conversation.dart';
import 'possessive/possessive.dart';
import 'svg_view.dart';
import 'vocabs/vocabs.dart';

// class Uplaod extends StatefulWidget {
//   const Uplaod({super.key});

//   @override
//   State<Uplaod> createState() => _UplaodState();
// }

// class _UplaodState extends State<Uplaod> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<UploadProvider>(
//       builder: (BuildContext context, value, child) {
//         return DefaultTabController(
//           length: 3, // Number of tabs
//           child: Scaffold(
//             appBar: AppBar(
//               title: const Text("Upload To Dictionary"),
//               bottom: const TabBar(
//                 tabs: [
//                   Tab(icon: Icon(Icons.home), text: 'Vocabs'),
//                   Tab(icon: Icon(Icons.search), text: 'Word'),
//                   Tab(icon: Icon(Icons.person), text: 'Conversation'),
//                 ],
//               ),
//             ),
//             body: TabBarView(
//               children: [
//                 Vocabs(value: value),
//                 Word(value: value),
//                 Conversation(value: value)
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

class Entries extends StatelessWidget {
  const Entries({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Entry"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const Grammatic());
                    },
                    child: const Text('Grammatical Cases')),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => const Vocabs());
                    },
                    child: const Text('Vocabulary')),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => Conversation());
                    },
                    child: const Text('Senetence')),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => Possessive());
                    },
                    child: const Text('Possessive')),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(() => SVGView());
                    },
                    child: const Text('View Possessive Pronouns')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
