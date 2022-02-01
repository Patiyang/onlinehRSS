import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rssadmin/views/home/home_page.dart';
import 'package:rssadmin/views/splash_screen.dart';

import 'models/theme_model.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getTheme();
  runApp(const MyApp());
}

getTheme() {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Rss',
      theme: ThemeModel().lightMode,
      darkTheme: ThemeModel().darkMode,
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
