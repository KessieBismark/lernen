import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/ai_verbs/provider_verb.dart';
import 'package:lernen/main_page.dart';
import 'package:lernen/utils/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'ai_conversation/provider.dart';
import 'ai_interview_prep/provider.dart';
import 'quiz/component/provider.dart';
import 'spelling/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SpellProvider()),
        ChangeNotifierProvider(create: (_) => AIVerbProvider()),
        ChangeNotifierProvider(create: (_) => AIInterviewProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lernen',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode:
              themeProvider.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
          home: const MainPage(),
        );
      },
    );
  }
}
