import 'package:flutter/material.dart';
import 'package:lernen/ai_verbs/storage/vocabs_view.dart';
import 'package:provider/provider.dart';

import '../utils/provider/theme_provider.dart';
import '../utils/sentence.dart';
import '../utils/speak.dart';

Widget displayGermanData(BuildContext context, dynamic jsonString) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final isDarkMode = themeProvider.isDarkTheme;

  final Map<dynamic, dynamic> jsonData = jsonString;

  final Map<String, dynamic>? germanData = jsonData['german_data'];
  final Map<String, dynamic>? dataForms = jsonData['data_forms'];
  final Map<String, dynamic>? exampleSentences = jsonData['example_sentences'];

  // Theme-aware colors
  final backgroundColor =
      isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50;
  final cardBackground = isDarkMode ? Colors.grey.shade800 : Colors.white;
  final textColor = isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800;
  final mutedTextColor =
      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

  // Section-specific colors (adjusted for dark mode)
  final blueSectionBg1 =
      isDarkMode ? Colors.blue.shade900.withOpacity(0.3) : Colors.blue.shade50;
  final blueSectionBg2 = isDarkMode ? Colors.grey.shade800 : Colors.white;
  final blueIconColor =
      isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;
  final blueTextColor =
      isDarkMode ? Colors.blue.shade300 : Colors.blue.shade900;
  final blueTagColor = isDarkMode ? Colors.blue.shade800 : Colors.blue.shade100;
  final blueTagTextColor =
      isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800;
  final blueBorderColor =
      isDarkMode ? Colors.blue.shade700.withOpacity(0.3) : Colors.blue.shade100;

  final purpleSectionBg1 = isDarkMode
      ? Colors.purple.shade900.withOpacity(0.3)
      : Colors.purple.shade50;
  final purpleSectionBg2 = isDarkMode ? Colors.grey.shade800 : Colors.white;
  final purpleIconColor =
      isDarkMode ? Colors.purple.shade300 : Colors.purple.shade700;
  final purpleTextColor =
      isDarkMode ? Colors.purple.shade300 : Colors.purple.shade900;
  final purpleTagColor =
      isDarkMode ? Colors.purple.shade800 : Colors.purple.shade100;
  final purpleTagTextColor =
      isDarkMode ? Colors.purple.shade200 : Colors.purple.shade800;
  final purpleBorderColor = isDarkMode
      ? Colors.purple.shade700.withOpacity(0.3)
      : Colors.purple.shade100;

  final greenSectionBg1 = isDarkMode
      ? Colors.green.shade900.withOpacity(0.3)
      : Colors.green.shade50;
  final greenSectionBg2 = isDarkMode ? Colors.grey.shade800 : Colors.white;
  final greenIconColor =
      isDarkMode ? Colors.green.shade300 : Colors.green.shade700;
  final greenTextColor =
      isDarkMode ? Colors.green.shade300 : Colors.green.shade900;
  final greenTagColor =
      isDarkMode ? Colors.green.shade800 : Colors.green.shade100;
  final greenTagTextColor =
      isDarkMode ? Colors.green.shade200 : Colors.green.shade800;
  final greenBorderColor = isDarkMode
      ? Colors.green.shade700.withOpacity(0.3)
      : Colors.green.shade100;

  return Consumer<ThemeProvider>(
    builder: (context, themeProvider, child) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // German Data Section
            if (germanData != null)
              Card(
                elevation: isDarkMode ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardBackground,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        blueSectionBg1,
                        blueSectionBg2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: isDarkMode
                        ? Border.all(color: Colors.grey.shade700)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.language, color: blueIconColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "German Word Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: blueTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ...germanData.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey.shade800
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: blueTagColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    entry.key.capitalize(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: blueTagTextColor,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: SelectableText(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 24),

            // Conjugations Section
            if (dataForms != null)
              Card(
                elevation: isDarkMode ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardBackground,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        purpleSectionBg1,
                        purpleSectionBg2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: isDarkMode
                        ? Border.all(color: Colors.grey.shade700)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_balance,
                              color: purpleIconColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Conjugations",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: purpleTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ...dataForms.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: purpleTagColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  entry.key.capitalize(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: purpleTagTextColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              if (entry.value is Map<String, dynamic>)
                                ...entry.value.entries.map((subEntry) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? Colors.grey.shade800
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: isDarkMode
                                            ? []
                                            : [
                                                BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  blurRadius: 2,
                                                  offset: Offset(0, 1),
                                                ),
                                              ],
                                        border: isDarkMode
                                            ? Border.all(
                                                color: Colors.grey.shade700)
                                            : null,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: SentenceRow(
                                          text:
                                              "${subEntry.key}: ${subEntry.value}",
                                        ),
                                      ),
                                    ),
                                  );
                                })
                              else
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isDarkMode
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 2,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                    border: isDarkMode
                                        ? Border.all(
                                            color: Colors.grey.shade700)
                                        : null,
                                  ),
                                  child: SentenceRow(text: entry.value),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 24),

            // Example Sentences Section
            if (exampleSentences != null)
              Card(
                elevation: isDarkMode ? 0 : 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: cardBackground,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        greenSectionBg1,
                        greenSectionBg2,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: isDarkMode
                        ? Border.all(color: Colors.grey.shade700)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              color: greenIconColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            "Example Sentences",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: greenTextColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      ...exampleSentences.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: greenTagColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  entry.key.capitalize(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: greenTagTextColor,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              sentenceExample(entry, isDarkMode),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      );
    },
  );
}

Widget sentenceExample(MapEntry<String, dynamic> entry, bool isDarkMode) {
  String text = entry.value.toString();
  List<String> parts;

  // Theme-aware colors for sentence example
  final exampleBgColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
  final sentenceBgColor =
      isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50;
  final infoBgColor = isDarkMode
      ? Colors.amber.shade900.withOpacity(0.3)
      : Colors.amber.shade50;
  final infoBorderColor =
      isDarkMode ? Colors.amber.shade800 : Colors.amber.shade100;
  final infoIconColor =
      isDarkMode ? Colors.amber.shade300 : Colors.amber.shade700;
  final infoTextColor =
      isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
  final speakButtonBg = isDarkMode
      ? Colors.green.shade800.withOpacity(0.5)
      : Colors.green.shade100;
  final speakButtonIcon =
      isDarkMode ? Colors.green.shade300 : Colors.green.shade700;

  if (text.contains("(")) {
    parts = text.split("(");
    return Container(
      decoration: BoxDecoration(
        color: exampleBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
        border: isDarkMode ? Border.all(color: Colors.grey.shade700) : null,
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: sentenceBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: isDarkMode
                        ? Border.all(color: Colors.grey.shade700)
                        : null,
                  ),
                  child: SentenceRow(text: parts[0].trim()),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: infoBgColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: infoBorderColor),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: infoIconColor, size: 16),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    "(${parts[1].trim()}",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: infoTextColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      decoration: BoxDecoration(
        color: exampleBgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isDarkMode
            ? []
            : [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 3,
                  offset: Offset(0, 2),
                ),
              ],
        border: isDarkMode ? Border.all(color: Colors.grey.shade700) : null,
      ),
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: sentenceBgColor,
                borderRadius: BorderRadius.circular(8),
                border:
                    isDarkMode ? Border.all(color: Colors.grey.shade700) : null,
              ),
              child: SentenceRow(text: text),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: speakButtonBg,
            ),
            child: IconButton(
              onPressed: () {
                Speak().speak(text: text.trim(), locale: "de-DE");
              },
              icon: Icon(Icons.volume_up, color: speakButtonIcon),
              tooltip: 'Listen',
            ),
          ),
        ],
      ),
    );
  }
}
