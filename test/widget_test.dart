import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freq_fit/main.dart';
import 'package:freq_fit/core/session.dart';
import 'package:freq_fit/core/tone.dart';
import 'package:freq_fit/ui/check_screen.dart';

class FakeTonePlayer extends TonePlayer {
  final List<(int, double, bool)> played = [];
  @override
  Future<void> play(int frequency, double dbfs, bool left) async {
    played.add((frequency, dbfs, left));
  }

  @override
  Future<void> stop() async {}
  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(() async {
    final loader = FontLoader('Blinker')
      ..addFont(rootBundle.load('assets/fonts/Blinker-Regular.ttf'));
    await loader.load();
  });
  late SessionStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = SessionStore(await SharedPreferences.getInstance());
  });
  testWidgets('Desktop overview and navigation show real empty states',
      (tester) async {
    tester.view.physicalSize = const Size(1440, 1050);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MyApp(store: store));
    expect(find.text('A little clarity goes a long way.'), findsOneWidget);
    await tester.tap(find.text('Session history'));
    await tester.pumpAndSettle();
    expect(find.text('A fresh start.'), findsOneWidget);
    await tester.tap(find.text('Your guide'));
    await tester.pumpAndSettle();
    expect(find.text('What your results mean'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Mobile overview fits and history is reachable', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MyApp(store: store));
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    expect(find.text('Your listening journey.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Saved response chart and text values fit a mobile dialog',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await store.save(HearingSession(
        id: 'mobile',
        name: 'Mobile check',
        date: DateTime(2026, 10, 27),
        levels: {'L250': -45, 'R250': -42}));
    await tester.pumpWidget(MyApp(store: store));
    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mobile check'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('View response values'));
    await tester.pumpAndSettle();
    expect(find.text('-45'), findsOneWidget);
    expect(find.text('-42'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Preparation gates audio, both ears record, session saves',
      (tester) async {
    tester.view.physicalSize = const Size(1100, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final tone = FakeTonePlayer();
    await tester.pumpWidget(MaterialApp(
        home: Builder(
            builder: (context) => Scaffold(
                body: TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) =>
                                CheckScreen(store: store, tonePlayer: tone))),
                    child: const Text('Open'))))));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Begin listening'))
            .onPressed,
        isNull);
    await tester.enterText(find.byType(TextFormField), 'Test check');
    for (final text in [
      'I’m in a quiet, comfortable space.',
      'My stereo headphones are on the correct ears.',
      'I understand this is an uncalibrated exploration.'
    ]) {
      await tester.tap(find.text(text));
      await tester.pump();
    }
    await tester.tap(find.text('Begin listening'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 12; i++) {
      await tester.tap(find.text('Play a 1-second tone'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1200));
      await tester.tap(find.text('Record response & continue'));
      await tester.pumpAndSettle();
    }
    expect(find.text('Here’s what you recorded.'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'Quiet room');
    await tester.tap(find.text('Save session'));
    await tester.pumpAndSettle();
    expect(store.sessions.single.complete, isTrue);
    expect(store.sessions.single.notes, 'Quiet room');
    expect(tone.played.length, 12);
    expect(tone.played.take(6).every((p) => p.$3), isTrue);
    expect(tone.played.skip(6).every((p) => !p.$3), isTrue);
    expect(tester.takeException(), isNull);
  });
}
