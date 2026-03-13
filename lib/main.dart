import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:note/l10n/app_localizations.dart';
import 'app_style.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Note",
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('it', ''),
        Locale('en', ''),
        Locale('fr', ''),
        Locale('pt', ''),
        Locale('ru', ''),
        Locale('zh', ''),
        Locale('de', ''),
        Locale('ja', ''),
      ],
      theme: ThemeData(
        useMaterial3: true,
        dialogTheme: AppStyle.dialogTheme,
        scaffoldBackgroundColor: AppStyle.background,
        searchBarTheme: AppStyle.searchBar,
        appBarTheme: AppStyle.appBar,
        floatingActionButtonTheme: AppStyle.floatingButton,
        textTheme: AppStyle.text,
        elevatedButtonTheme: AppStyle.elevatedButton,
        iconButtonTheme: AppStyle.iconButton,
      ),

      home: const HomePage(),
    );
  }
}
