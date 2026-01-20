import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/utils/speak.dart';
import 'package:provider/provider.dart';
import '../utils/provider/theme_provider.dart';
import '../utils/topbar.dart';
import 'provider.dart';

class Spelling extends StatefulWidget {
  const Spelling({super.key});

  @override
  State<Spelling> createState() => _SpellingState();
}

class _SpellingState extends State<Spelling> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkTheme;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Consumer<SpellProvider>(
          builder: (BuildContext context, SpellProvider value, Widget? child) {
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
            final successColor =
                isDarkMode ? Colors.green.shade400 : Colors.green;
            final errorColor = isDarkMode ? Colors.red.shade400 : Colors.red;
            final primaryColor =
                isDarkMode ? Colors.blue.shade300 : Colors.blue;
            final iconColor =
                isDarkMode ? Colors.blue.shade300 : Colors.blue.shade700;

            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                value.viewWord = false;
              },
              child: Scaffold(
                backgroundColor: backgroundColor,
                body: SafeArea(
                  child: Column(
                    children: [
                      TopBar(),

                      // Score Display
                      Container(
                        margin: EdgeInsets.all(20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isDarkMode
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                          border: isDarkMode
                              ? Border.all(color: Colors.grey.shade700)
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Progress",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                "Score: ${value.marks}/${value.wordCounter}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 40),

                      // Pronunciation and View Word Buttons
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Listen Button
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cardColor,
                                    boxShadow: isDarkMode
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      Speak().speak(
                                          text: value.word, locale: "de-DE");
                                    },
                                    icon: Icon(
                                      Icons.volume_up,
                                      size: 40,
                                      color: iconColor,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: cardColor,
                                      padding: EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Listen",
                                  style: TextStyle(
                                    color: hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(width: 40),

                            // View Word Button
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cardColor,
                                    boxShadow: isDarkMode
                                        ? []
                                        : [
                                            BoxShadow(
                                              color: Colors.grey.shade200,
                                              blurRadius: 8,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      value.viewWord = true;
                                      value.correct = 2;
                                      _showBottomDialog(context, isDarkMode);
                                    },
                                    icon: Icon(
                                      Icons.visibility,
                                      size: 40,
                                      color: iconColor,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: cardColor,
                                      padding: EdgeInsets.all(16),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Show Answer",
                                  style: TextStyle(
                                    color: hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 60),

                      // Input Field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
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
                          child: TextField(
                            maxLines: 3,
                            controller: value.wordController,
                            style: TextStyle(
                              fontSize: 18,
                              color: textColor,
                            ),
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Type the word here...',
                              hintStyle: TextStyle(
                                color: hintColor,
                                fontSize: 16,
                              ),
                              filled: true,
                              fillColor: cardColor,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: borderColor,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: primaryColor,
                                  width: 2,
                                ),
                              ),
                              contentPadding: EdgeInsets.all(20),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Continue Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: value.viewWord
                                ? null
                                : () {
                                    if (value.wordController.text.isEmpty) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: cardColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            title: Text(
                                              "Attention",
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            content: Text(
                                              "Please write the word before continuing.",
                                              style: TextStyle(
                                                color: textColor,
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      if (value.word.toLowerCase() ==
                                          value.wordController.text
                                              .trim()
                                              .toLowerCase()) {
                                        value.marks += 1;
                                        value.correct = 1;
                                        value.viewWord = true;
                                      } else {
                                        value.correct = 0;
                                        value.viewWord = true;
                                      }
                                      value.wordCounter += 1;
                                      _showBottomDialog(context, isDarkMode);
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: value.viewWord
                                  ? Colors.grey.shade600
                                  : primaryColor,
                              disabledBackgroundColor: Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 3,
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: value.isSave
                                ? SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    "Check Answer",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),

                      // Hint
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Hint: Click outside the text field or press the device's back button to dismiss keyboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: hintColor,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
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

  void _showBottomDialog(BuildContext context, bool isDarkMode) {
    final value = context.read<SpellProvider>();

    // Theme-aware colors for bottom dialog
    final dialogBgColor = isDarkMode ? Colors.grey.shade800 : Colors.white;
    final textColor = isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800;
    final successBgColor = isDarkMode
        ? Colors.green.shade900.withOpacity(0.3)
        : Colors.green.shade50;
    final successBorderColor =
        isDarkMode ? Colors.green.shade800 : Colors.green.shade200;
    final errorBgColor =
        isDarkMode ? Colors.red.shade900.withOpacity(0.3) : Colors.red.shade50;
    final errorBorderColor =
        isDarkMode ? Colors.red.shade800 : Colors.red.shade200;
    final infoBgColor = isDarkMode
        ? Colors.blue.shade900.withOpacity(0.3)
        : Colors.blue.shade50;
    final infoBorderColor =
        isDarkMode ? Colors.blue.shade800 : Colors.blue.shade200;
    final primaryColor = isDarkMode ? Colors.blue.shade300 : Colors.blue;

    showModalBottomSheet(
      isDismissible: false,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dialogBgColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            boxShadow: isDarkMode
                ? []
                : [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: Offset(0, -4),
                    ),
                  ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: 20),

              // Result Display
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: value.correct == 1
                      ? successBgColor
                      : value.correct == 0
                          ? errorBgColor
                          : infoBgColor,
                  border: Border.all(
                    color: value.correct == 1
                        ? successBorderColor
                        : value.correct == 0
                            ? errorBorderColor
                            : infoBorderColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (value.correct == 1)
                      Icon(
                        Icons.check_circle,
                        size: 32,
                        color: Colors.green,
                      )
                    else if (value.correct == 0)
                      Icon(
                        Icons.error,
                        size: 32,
                        color: Colors.red,
                      )
                    else
                      Icon(
                        Icons.visibility,
                        size: 32,
                        color: Colors.blue,
                      ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.word.capitalize!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "(${value.eng})",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Next Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      value.wordShower();
                      value.viewWord = false;
                      Navigator.pop(context);
                      setState(() {});
                      value.wordController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),
                    child: Text(
                      'Next Word',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
