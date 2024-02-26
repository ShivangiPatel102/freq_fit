import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freq_fit/firebase_options.dart';
import 'package:freq_fit/screens/home_screen.dart';
import 'package:freq_fit/screens/login_screen.dart';
// import 'package:freq_fit/screens/pta_results_screen.dart';
import 'package:freq_fit/screens/pta_test_screen.dart';
import 'package:freq_fit/screens/pure_tone_screen.dart';
import 'package:freq_fit/screens/registration_screen.dart';
import 'package:freq_fit/screens/splash_screen.dart';
import 'package:freq_fit/widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(scaffoldBackgroundColor: Color(0xffefeeee)),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthenticationWrapper(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/ptaTest': (context) => PtaTestScreen(),
        '/pureTone': (context) => PureToneScreen(),
        
      },
    );
  }
}
