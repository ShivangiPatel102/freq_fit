import 'package:flutter/material.dart';
import 'package:freq_fit/screens/home_screen.dart';
import 'package:freq_fit/screens/login_screen.dart';
import 'package:freq_fit/screens/pta_test_screen.dart';
import 'package:freq_fit/screens/pure_tone_screen.dart';
import 'package:freq_fit/screens/registration_screen.dart';
import 'package:freq_fit/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/pureTone',
      routes: {
        '/login': (context) =>  Login(),
        '/register' : (context) =>  RegisterScreen(),
        '/home' : (context) =>  HomeScreen(),
        '/ptaTest': (context) =>  PtaTestScreen(),
        '/pureTone': (context) =>  PureToneScreen(),

      },
    );
  }
}
