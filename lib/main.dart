import 'package:flutter/material.dart';
import 'package:freq_fit/screens/homescreen.dart';
import 'package:freq_fit/screens/login.dart';
import 'package:freq_fit/screens/ptaTest.dart';
import 'package:freq_fit/screens/register.dart';
import 'package:freq_fit/screens/splash_screen.dart';
import 'package:freq_fit/widgets/alert_check_headphone.dart';
import 'package:freq_fit/widgets/alert_select_ear.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const Login(),
        '/register' : (context) => const RegisterScreen(),
        '/home' : (context) => const HomeScreen(),
        '/ptaTest': (context) => const PtaTest(),
      },
    );
  }
}
