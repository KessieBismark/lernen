import 'package:lernen/conversations/provider.dart';
import 'package:lernen/entries_fold/grammatics/provider.dart';
import 'package:lernen/entries_fold/possessive/provider.dart';
import 'package:lernen/entries_fold/sentence/provider.dart';
import 'package:lernen/entries_fold/vocabs/u_provider.dart';
import 'package:lernen/spelling/provider.dart';
import 'package:provider/provider.dart';

import '../../verb/provider.dart';
import 'theme_provider.dart';


 final providerList = [
   ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ConProvider()),
        ChangeNotifierProvider(create: (_) => GrammerProvider()),
        ChangeNotifierProvider(create: (_) => PoProvider()),
        ChangeNotifierProvider(create: (_) => VerbProvider()),
        ChangeNotifierProvider(create: (_) => SpellProvider()),
        ChangeNotifierProvider(create: (_) => ConversationProvider()),
];