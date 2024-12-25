import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lernen/ai_verbs/provider_verb.dart';
import 'package:lernen/entries_fold/possessive/provider.dart';
import 'package:lernen/main_page.dart';
import 'package:lernen/entries_fold/vocabs/u_provider.dart';
import 'package:lernen/utils/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'ai_conversation/provider.dart';
import 'ai_interview_prep/provider.dart';
import 'conversations/provider.dart';
import 'entries_fold/grammatics/provider.dart';
import 'entries_fold/sentence/provider.dart';
import 'spelling/provider.dart';
import 'verb/provider.dart';

void main() {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConProvider()),
        ChangeNotifierProvider(create: (_) => GrammerProvider()),
        ChangeNotifierProvider(create: (_) => PoProvider()),
        ChangeNotifierProvider(create: (_) => VerbProvider()),
        ChangeNotifierProvider(create: (_) => SpellProvider()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
        ChangeNotifierProvider(create: (_) => AIVerbProvider()),
        ChangeNotifierProvider(create: (_) => AIInterviewProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),

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
