import 'package:flutter/material.dart';
import 'package:lernen/utils/waiting.dart';
import 'package:provider/provider.dart';
import '../utils/provider/theme_provider.dart';
import '../utils/sentence.dart';
import '../utils/topbar.dart';
import 'component/provider.dart';

class Quiz extends StatelessWidget {
  const Quiz({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Consumer<QuizProvider>(
          builder: (BuildContext context, QuizProvider value, Widget? child) {
            final isDarkMode = themeProvider.isDarkTheme;

            // Theme-aware colors
            final backgroundColor =
                isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50;
            final cardColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
            final textColor =
                isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800;
            final hintColor =
                isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;
            final borderColor =
                isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
            final primaryColor =
                isDarkMode ? Colors.blue.shade300 : Colors.blue;
            final successColor =
                isDarkMode ? Colors.green.shade400 : Colors.green;
            final errorColor = isDarkMode ? Colors.red.shade400 : Colors.red;
            final mutedColor =
                isDarkMode ? Colors.grey.shade600 : Colors.grey.shade400;

            return RefreshIndicator(
              onRefresh: () async {
                value.quizes = [];
                value.getQuizes();
              },
              backgroundColor: cardColor,
              color: primaryColor,
              child: Scaffold(
                backgroundColor: backgroundColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      TopBar(
                        widget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: borderColor,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: SizedBox(
                                width: 200,
                                child: DropdownButton<String>(
                                  menuMaxHeight: 500,
                                  isExpanded: true,
                                  underline: SizedBox(),
                                  dropdownColor: cardColor,
                                  hint: Text(
                                    'Select a level',
                                    style: TextStyle(color: hintColor),
                                  ),
                                  value: value.selectedLevel,
                                  onChanged: (val) {
                                    value.setSelected(val);
                                  },
                                  items: value.level
                                      .map<DropdownMenuItem<String>>((item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }).toList(),
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: primaryColor,
                                  ),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Progress and Score
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isDarkMode
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                          border: isDarkMode
                              ? Border.all(color: borderColor)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Question',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: hintColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${value.currentQuestionIndex + 1}/${value.quizes.length}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: borderColor,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Score',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: hintColor,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '${value.score}/${value.quizes.length}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

                      value.load
                          ? Expanded(child: MWaiting())
                          : Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: ListView(
                                  children: [
                                    // Question Card
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: cardColor,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: borderColor,
                                          width: 1.5,
                                        ),
                                        boxShadow: isDarkMode
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Colors.grey.shade100,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.help_outline,
                                                color: primaryColor,
                                                size: 20,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Question',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),
                                          SentenceRow(
                                            text:
                                                value.currentQuestion!.question,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 24),

                                    // Options Grid
                                    Text(
                                      'Choose the correct answer:',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount:
                                          value.currentQuestion!.options.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 1,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 6,
                                      ),
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        String letter =
                                            String.fromCharCode(65 + index);
                                        final option = value
                                            .currentQuestion!.options[index];
                                        final isSelected =
                                            value.selectedAnswer == option;
                                        final isCorrectOption = option ==
                                            value
                                                .currentQuestion!.correctAnswer;

                                        Color optionColor;
                                        if (value.isAnswered) {
                                          if (isCorrectOption) {
                                            optionColor =
                                                successColor.withOpacity(0.2);
                                          } else if (isSelected &&
                                              !isCorrectOption) {
                                            optionColor =
                                                errorColor.withOpacity(0.2);
                                          } else {
                                            optionColor = cardColor;
                                          }
                                        } else {
                                          optionColor = isSelected
                                              ? primaryColor.withOpacity(0.1)
                                              : cardColor;
                                        }

                                        return GestureDetector(
                                          onTap: value.isAnswered
                                              ? null
                                              : () {
                                                  value.checkAnswer(option);
                                                },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: optionColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: value.isAnswered
                                                    ? isCorrectOption
                                                        ? successColor
                                                            .withOpacity(0.5)
                                                        : isSelected &&
                                                                !isCorrectOption
                                                            ? errorColor
                                                                .withOpacity(
                                                                    0.5)
                                                            : borderColor
                                                    : isSelected
                                                        ? primaryColor
                                                        : borderColor,
                                                width: isSelected ||
                                                        (value.isAnswered &&
                                                            isCorrectOption)
                                                    ? 2
                                                    : 1.5,
                                              ),
                                              boxShadow: isDarkMode
                                                  ? []
                                                  : [
                                                      BoxShadow(
                                                        color: Colors
                                                            .grey.shade100,
                                                        blurRadius: 3,
                                                        offset: Offset(0, 2),
                                                      ),
                                                    ],
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(16),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 32,
                                                    height: 32,
                                                    decoration: BoxDecoration(
                                                      color: value.isAnswered &&
                                                              isCorrectOption
                                                          ? successColor
                                                          : value.isAnswered &&
                                                                  isSelected &&
                                                                  !isCorrectOption
                                                              ? errorColor
                                                              : isSelected
                                                                  ? primaryColor
                                                                  : Colors
                                                                      .transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        color: isSelected
                                                            ? primaryColor
                                                            : borderColor,
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        letter,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isSelected ||
                                                                  (value.isAnswered &&
                                                                      (isCorrectOption ||
                                                                          isSelected))
                                                              ? Colors.white
                                                              : hintColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Expanded(
                                                    child: SentenceRow(
                                                      text: option,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 32),

                                    // Answer Explanation (only shown when answered)
                                    if (value.isAnswered)
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: cardColor,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          border: Border.all(
                                            color: value.isCorrect
                                                ? successColor.withOpacity(0.3)
                                                : errorColor.withOpacity(0.3),
                                            width: 1.5,
                                          ),
                                          boxShadow: isDarkMode
                                              ? []
                                              : [
                                                  BoxShadow(
                                                    color: Colors.grey.shade100,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Result Indicator
                                            Row(
                                              children: [
                                                Icon(
                                                  value.isCorrect
                                                      ? Icons.check_circle
                                                      : Icons.error,
                                                  color: value.isCorrect
                                                      ? successColor
                                                      : errorColor,
                                                  size: 24,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  value.isCorrect
                                                      ? 'Correct!'
                                                      : 'Incorrect',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: value.isCorrect
                                                        ? successColor
                                                        : errorColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 20),

                                            // English Translation
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.translate,
                                                  size: 20,
                                                  color: primaryColor,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'English Translation:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: primaryColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              value.currentQuestion!.english,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: textColor,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            SizedBox(height: 16),

                                            // Explanation
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.lightbulb_outline,
                                                  size: 20,
                                                  color: Colors.amber.shade600,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Explanation:',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        Colors.amber.shade600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              value.currentQuestion!
                                                  .explaination,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: textColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    SizedBox(height: 24),

                                    // Next Question Button
                                    if (value.isAnswered)
                                      SizedBox(
                                        width: double.infinity,
                                        height: 56,
                                        child: ElevatedButton(
                                          onPressed: value.nextQuestion,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            elevation: 3,
                                          ),
                                          child: Text(
                                            value.currentQuestionIndex + 1 <
                                                    value.quizes.length
                                                ? 'Next Question'
                                                : 'Finish Quiz',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(height: 32),

                                    // Disclaimer
                                    Container(
                                      padding: EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade50
                                            .withOpacity(isDarkMode ? 0.1 : 1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.green.shade200
                                              .withOpacity(
                                                  isDarkMode ? 0.3 : 1),
                                        ),
                                      ),
                                      child: Text(
                                        "This application is backed by AI and therefore might have wrong or incorrect data. This is for training and assisting purpose only.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green.shade700,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
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
      },
    );
  }
}
