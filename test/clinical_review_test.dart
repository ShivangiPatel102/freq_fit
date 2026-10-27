import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freq_fit/core/session.dart';
import 'package:freq_fit/main.dart';
import 'package:freq_fit/ui/clinical_review.dart';

void main() {
  setUpAll(() async {
    final loader = FontLoader('Blinker')
      ..addFont(rootBundle.load('assets/fonts/Blinker-Regular.ttf'));
    await loader.load();
  });
  testWidgets('Clinical workspace is reachable from hearing checks on mobile',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(
        MyApp(store: SessionStore(await SharedPreferences.getInstance())));
    await tester.tap(find.text('Checks'));
    await tester.pumpAndSettle();
    final entry = find.text('Review a calibrated audiogram');
    await tester.ensureVisible(entry);
    await tester.tap(entry);
    await tester.pumpAndSettle();
    expect(find.text('From measurements to observations.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
      'Confirmations gate results, edit invalidates old observations, mobile report fits',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MaterialApp(home: ClinicalReview()));
    final example = find.text('Load synthetic example');
    await tester.ensureVisible(example);
    await tester.tap(example);
    await tester.pumpAndSettle();
    final generate = find.text('Generate observations');
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pumpAndSettle();
    expect(find.text('Calibration is unconfirmed'), findsOneWidget);
    expect(find.text('Imported air-conduction thresholds'), findsNothing);
    for (final checkbox in [
      find.text(
          'I confirm these are calibrated dB HL air-conduction thresholds.'),
      find.text('A clinician has reviewed measurement reliability.')
    ]) {
      await tester.ensureVisible(checkbox);
      await tester.tap(checkbox);
      await tester.pumpAndSettle();
    }
    expect(find.text('Calibration is unconfirmed'), findsNothing);
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pumpAndSettle();
    expect(find.text('Imported air-conduction thresholds'), findsOneWidget);
    expect(find.text('Left: three-frequency average'), findsOneWidget);
    final chart = find.text('Imported air-conduction thresholds');
    await tester.ensureVisible(chart);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final field = find.widgetWithText(TextField, 'Adult age (years)');
    await tester.ensureVisible(field);
    await tester.enterText(field, '17');
    await tester.pumpAndSettle();
    expect(find.text('Left: three-frequency average'), findsNothing);
    await tester.ensureVisible(generate);
    await tester.tap(generate);
    await tester.pumpAndSettle();
    expect(find.text('Outside supported adult age range'), findsOneWidget);
    expect(find.text('Imported air-conduction thresholds'), findsNothing);
  });
}
