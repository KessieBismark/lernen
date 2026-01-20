import 'package:flutter/material.dart';
import 'package:lernen/ai_interview_prep/model.dart';
import 'package:provider/provider.dart';
import '../utils/provider/theme_provider.dart';
import '../utils/sentence.dart';

class ConversationScreen extends StatelessWidget {
  final List<ConversationEntry> conversation;

  const ConversationScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkTheme;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Container(
          color: isDarkMode ? Colors.grey.shade900 : Colors.grey.shade50,
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: conversation.length,
            itemBuilder: (context, index) {
              final message = conversation[index];
              final isPerson1 = index % 2 == 0; // Alternating messages

              // Colors that adapt to theme
              final person1BubbleColor = isDarkMode
                  ? Colors.blue.shade900.withOpacity(0.3)
                  : Colors.blue.shade50;
              final person1BorderColor =
                  isDarkMode ? Colors.blue.shade700 : Colors.blue.shade200;
              final person1TextColor =
                  isDarkMode ? Colors.blue.shade200 : Colors.blue.shade800;
              final person1AvatarColor =
                  isDarkMode ? Colors.blue.shade800 : Colors.blueAccent;
              final person1ShadowColor = isDarkMode
                  ? Colors.blue.shade900.withOpacity(0.4)
                  : Colors.blue.shade100;

              final person2BubbleColor = isDarkMode
                  ? Colors.green.shade900.withOpacity(0.3)
                  : Colors.green.shade50;
              final person2BorderColor =
                  isDarkMode ? Colors.green.shade700 : Colors.green.shade200;
              final person2TextColor =
                  isDarkMode ? Colors.green.shade200 : Colors.green.shade800;
              final person2AvatarColor =
                  isDarkMode ? Colors.green.shade800 : Colors.green;
              final person2ShadowColor = isDarkMode
                  ? Colors.green.shade900.withOpacity(0.4)
                  : Colors.green.shade100;

              final translationBgColor =
                  isDarkMode ? Colors.grey.shade800 : Colors.white;
              final translationTextColor =
                  isDarkMode ? Colors.grey.shade300 : Colors.grey.shade700;
              final iconColor =
                  isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600;

              return Container(
                margin: EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PERSON 1 (Left side)
                    if (isPerson1) ...[
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: person1AvatarColor,
                        child: Text(
                          "P1",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),

                      // Message content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.speaker,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: person1TextColor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),

                            // Message bubble
                            Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade800.withOpacity(0.8)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                boxShadow: isDarkMode
                                    ? [] // No shadow in dark mode for cleaner look
                                    : [
                                        BoxShadow(
                                          color: person1ShadowColor,
                                          blurRadius: 4,
                                          offset: Offset(1, 2),
                                        ),
                                      ],
                                border: Border.all(
                                  color: person1BorderColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // German text
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: person1BubbleColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: SentenceRow(
                                      text: message.german,
                                    ),
                                  ),

                                  // English translation
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: translationBgColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.language,
                                          size: 16,
                                          color: iconColor,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            message.english,
                                            style: TextStyle(
                                              color: translationTextColor,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // PERSON 2 (Right side)
                    if (!isPerson1) ...[
                      // Message content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              message.speaker,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: person2TextColor,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),

                            // Message bubble
                            Container(
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey.shade800.withOpacity(0.8)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16),
                                ),
                                boxShadow: isDarkMode
                                    ? [] // No shadow in dark mode
                                    : [
                                        BoxShadow(
                                          color: person2ShadowColor,
                                          blurRadius: 4,
                                          offset: Offset(-1, 2),
                                        ),
                                      ],
                                border: Border.all(
                                  color: person2BorderColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // German text
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: person2BubbleColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(8),
                                      ),
                                    ),
                                    child: SentenceRow(
                                      text: message.german,
                                    ),
                                  ),

                                  // English translation
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: translationBgColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(16),
                                        bottomRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.language,
                                          size: 16,
                                          color: iconColor,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            message.english,
                                            style: TextStyle(
                                              color: translationTextColor,
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),

                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: person2AvatarColor,
                        child: Text(
                          "P2",
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
