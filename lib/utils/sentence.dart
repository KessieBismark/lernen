import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'highlight.dart';
import 'provider/theme_provider.dart';
import 'speak.dart';


class SentenceRow extends StatefulWidget {
  final String text;

  const SentenceRow({super.key, required this.text});

  @override
  _SentenceRowState createState() => _SentenceRowState();
}

class _SentenceRowState extends State<SentenceRow> {
  int activeWord = -1;
  bool _isSpeaking = false;
  final Speak _speak = Speak();

  void _handleStop() {
    _speak.stop();
    setState(() {
      _isSpeaking = false;
      activeWord = -1;
    });
  }

  void _handlePlay() {
    setState(() {
      _isSpeaking = true;
    });

    _speak.speakWithHighlight(
      text: widget.text,
      locale: "de-DE",
      onProgress: (index) {
        if (mounted) {
          setState(() {
            activeWord = index;
            if (index == -1) {
              _isSpeaking = false;
            }
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _speak.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkTheme;
    
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: HighlightableText(
              text: widget.text,
              activeIndex: activeWord,
            ),
          ),
          SizedBox(width: 8),
          // Play button
          AnimatedOpacity(
            opacity: _isSpeaking ? 0.0 : 1.0,
            duration: Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: _isSpeaking,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode 
                      ? Colors.blue.shade800.withOpacity(0.5)
                      : Colors.blue.shade100,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.volume_up, 
                    color: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700, 
                    size: 20
                  ),
                  onPressed: _handlePlay,
                ),
              ),
            ),
          ),
          // Stop button
          AnimatedOpacity(
            opacity: _isSpeaking ? 1.0 : 0.0,
            duration: Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: !_isSpeaking,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDarkMode 
                      ? Colors.red.shade800.withOpacity(0.5)
                      : Colors.red.shade100,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.stop, 
                    color: isDarkMode ? Colors.red.shade200 : Colors.red.shade700, 
                    size: 20
                  ),
                  onPressed: _handleStop,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}