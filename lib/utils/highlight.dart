import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/theme_provider.dart'; // Import your ThemeProvider

class HighlightableText extends StatelessWidget {
  final String text;
  final int activeIndex;

  const HighlightableText({super.key, 
    required this.text,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkTheme;
    
    final words = text.split(RegExp(r"\s+"));

    return RichText(
      text: TextSpan(
        children: [
          for (int i = 0; i < words.length; i++)
            TextSpan(
              text: "${words[i]} ",
              style: TextStyle(
                fontSize: 16,
                color: i == activeIndex 
                    ? Colors.blueAccent 
                    : isDarkMode 
                        ? Colors.grey.shade200 
                        : Colors.grey.shade800,
                fontWeight:
                    i == activeIndex ? FontWeight.bold : FontWeight.normal,
              ),
            ),
        ],
      ),
    );
  }
}