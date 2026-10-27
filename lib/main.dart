import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/session.dart';
import 'ui/workspace.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final preferences = await SharedPreferences.getInstance();
    runApp(MyApp(store: SessionStore(preferences)));
  } catch (_) {
    runApp(const MaterialApp(
        home: Scaffold(
            body: Center(
                child: Text(
                    'Local storage is unavailable. Enable storage and restart FreqFit.')))));
  }
}

class MyApp extends StatelessWidget {
  final SessionStore store;
  const MyApp({super.key, required this.store});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'FreqFit · A little clarity, a better connection',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Blinker',
          scaffoldBackgroundColor: const Color(0xFFF6F7F9),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF5462D6),
              primary: const Color(0xFF5462D6),
              surface: Colors.white),
          textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Blinker',
              bodyColor: const Color(0xFF252940),
              displayColor: const Color(0xFF252940)),
          filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)))),
          outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
                  side: const BorderSide(color: Color(0xFFE1E4ED)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)))),
          inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFFF6F7FA),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(18)),
        ),
        home: Workspace(store: store),
      );
}
