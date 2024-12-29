import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import '../utils/speak.dart';
import '../utils/topbar.dart';
import 'component/provider.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (BuildContext context, QuizProvider value, Widget? child) {
        return RefreshIndicator(
          onRefresh: () async {
            value.quizes = [];
            await value.getQuizes();
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  TopBar(
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SizedBox(
                        width: 200,
                        child: DropdownButton<String>(
                          menuMaxHeight: 500,
                          isExpanded: true,
                          hint: Text('Select a level'),
                          value: value.selectedLevel,
                          onChanged: (val) {
                            value.setSelected(val);
                          },
                          items:
                              value.level.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  value.load
                      ? Expanded(child: MWaiting())
                      : Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Question ${value.currentQuestionIndex + 1}/${value.quizes.length}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Score ${value.score + 1}/${value.quizes.length}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SelectableText(
                                        utf8.decode(value.currentQuestion!
                                            .question.codeUnits),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Speak().speak(
                                            text: utf8.decode(value
                                                .currentQuestion!
                                                .question
                                                .codeUnits),
                                            locale: "de-DE");
                                      },
                                      icon: Icon(Icons.volume_up),
                                      tooltip: 'Listen',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                GridView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        value.currentQuestion!.options.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 25.0,
                                            childAspectRatio: 7,
                                            crossAxisCount: 1),
                                    itemBuilder: (BuildContext context, index) {
                                      String letter =
                                          String.fromCharCode(65 + index);
                                      return GestureDetector(
                                        onTap: value.isAnswered
                                            ? null
                                            : () {
                                                value.checkAnswer(utf8.decode(
                                                    value
                                                        .currentQuestion!
                                                        .options[index]
                                                        .codeUnits));
                                              },
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: value.selectedAnswer ==
                                                    utf8.decode(value
                                                        .currentQuestion!
                                                        .options[index]
                                                        .codeUnits)
                                                ? value.isCorrect
                                                    ? Colors.green
                                                    : value.isSelected
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            59, 238, 238, 238)
                                                : value.isSelected
                                                    ? const Color.fromARGB(
                                                        83, 187, 222, 251)
                                                    : const Color.fromARGB(
                                                        77, 238, 238, 238),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "($letter). ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  utf8.decode(value
                                                      .currentQuestion!
                                                      .options[index]
                                                      .codeUnits),
                                                ),
                                              ),
                                              IconButton(
                                                padding:
                                                    EdgeInsets.only(top: -5),
                                                onPressed: () {
                                                  Speak().speak(
                                                      text: utf8.decode(value
                                                          .currentQuestion!
                                                          .options[index]
                                                          .codeUnits),
                                                      locale: "de-DE");
                                                },
                                                icon: Icon(Icons.volume_up),
                                                tooltip: 'Listen',
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(height: 24),
                                if (value.isAnswered)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'English:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        utf8.decode(value.currentQuestion!
                                            .english.codeUnits),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const Text(
                                        'Explanation:',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        utf8.decode(value.currentQuestion!
                                            .explaination.codeUnits),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 24),
                                if (value.isAnswered)
                                  ElevatedButton(
                                    onPressed: value.nextQuestion,
                                    child: const Text('Next Question'),
                                  ),
                                SizedBox(
                                  height: 30,
                                ),
                                const Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "This application is backed by AI and therefore might have wrong or incorrect data. This is for training and assisting purpose only.",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
