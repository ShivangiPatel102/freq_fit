import 'package:flutter/material.dart';
import 'package:freq_fit/screens/home_screen.dart';
import 'package:freq_fit/screens/login_screen.dart';
import 'package:freq_fit/screens/pta_test_screen.dart';
import 'package:freq_fit/screens/pure_tone_screen.dart';
import 'package:freq_fit/screens/registration_screen.dart';
import 'package:freq_fit/screens/splash_screen.dart';
import 'package:freq_fit/widgets/alert_check_headphone.dart';
import 'package:freq_fit/widgets/alert_select_ear.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) =>  Login(),
        '/register' : (context) =>  RegisterScreen(),
        '/home' : (context) =>  HomeScreen(),
        '/ptaTest': (context) =>  PtaTestScreen(),
        '/pureTone': (context) =>  PureToneScreen(),

      },
    );
  }
}
