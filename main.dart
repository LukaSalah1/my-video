import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uusi_video/about_us.dart';
import 'package:uusi_video/contact_us.dart';
import 'package:uusi_video/search_page.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart'; // Your generated localization file

import 'home_page.dart';
import 'watch_video_page.dart';
import 'video_desc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static final unlockedVideos = <String>{}; // Simple in-memory store

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.changeLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = Locale('fi');

  void changeLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pay to Watch',
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: _locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/watch': (context) => WatchVideoPage(),
        '/vidDesc': (context) => VideoDesc(),
        '/aboutUs': (context) => AboutUs(),
        '/contactUs': (context) => ContactUs(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}
