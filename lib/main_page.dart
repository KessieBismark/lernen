import 'package:flutter/material.dart';
import 'package:lernen/ai_interview_prep/interview.dart';
import 'package:lernen/ai_verbs/ai_verb.dart';
import 'ai_conversation/chat.dart';
import 'quiz/quiz.dart';
import 'spelling/spelling.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Quiz(),
    Spelling(),
    AIVerbAssit(),
    AIInterviewAssit(),
    ChatConversation()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Quiz',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spatial_tracking_outlined),
              label: 'Spelling',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_for_work_outlined),
              label: 'Verbs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'Convo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.record_voice_over),
              label: 'Chat',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
