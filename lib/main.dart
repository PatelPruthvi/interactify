import 'package:chat_app/screens/home/ui/homescreen.dart';
import 'package:chat_app/themes/brightness_change_notify.dart';
import 'package:chat_app/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BrightnessNotifier(
      onBrightnessChanged: () {
        setState(() {});
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.system,
        darkTheme: darkTheme,
        theme: lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
