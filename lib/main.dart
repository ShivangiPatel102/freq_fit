import 'package:flutter/material.dart';
import 'package:freq_fit/screens/HomeScreen.dart';
import 'package:freq_fit/screens/register.dart';
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
      home: SplashScreen(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/register' : (context) => RegisterScreen(),
      },
    );
  }
}
