import 'package:flutter_test/flutter_test.dart';
import 'package:freq_fit/core/clinical_rules.dart';

AudiogramInput input(
        {Map<int, double>? left,
        Map<int, double>? right,
        MeasurementUnit unit = MeasurementUnit.dbHL,
        bool calibrated = true,
        bool reliable = true,
        int age = 45,
        String source = 'Test fixture'}) =>
    AudiogramInput(
        left:
            left ?? {250: 10, 500: 20, 1000: 30, 2000: 40, 4000: 50, 8000: 60},
        right:
            right ?? {250: 10, 500: 10, 1000: 10, 2000: 10, 4000: 10, 8000: 10},
        unit: unit,
        calibrated: calibrated,
        reliabilityConfirmed: reliable,
        age: age,
        source: source);
void main() {
  final engine = ClinicalRulesEngine();
  test(
      'Clinical calculations are withheld for dBFS regardless of confirmations',
      () {
    final r = engine.evaluate(input(unit: MeasurementUnit.dbFS));
    expect(r.blocked, isTrue);
    expect(r.observations.map((o) => o.ruleId), contains('G01'));
    expect(r.observations.any((o) => o.ruleId.startsWith('D')), isFalse);
  });
  test('Every provenance gate blocks clinical output', () {
    for (final i in [
      input(unit: MeasurementUnit.unknown),
      input(calibrated: false),
      input(reliable: false),
      input(age: 17),
      input(age: 121),
      input(source: ' '),
      input(left: {}, right: {})
    ]) {
      final r = engine.evaluate(i);
      expect(r.blocked, isTrue);
      expect(r.observations.every((o) => o.kind == ObservationKind.blocked),
          isTrue);
    }
  });
  test(
      'Invalid numeric values and unsupported frequencies cannot bypass CSV validation',
      () {
    for (final values in [
      {250: double.nan},
      {250: double.infinity},
      {250: -11.0},
      {250: 121.0},
      {250: 15.5},
      {123: 20.0}
    ]) {
      expect(engine.evaluate(input(left: values)).blocked, isTrue);
    }
  });
  test('All ASHA band boundaries are explicit and inclusive', () {
    final cases = {
      -10: 'Normal range',
      15: 'Normal range',
      16: 'Slight',
      25: 'Slight',
      26: 'Mild',
      40: 'Mild',
      41: 'Moderate',
      55: 'Moderate',
      56: 'Moderately severe',
      70: 'Moderately severe',
      71: 'Severe',
      90: 'Severe',
      91: 'Profound',
      120: 'Profound'
    };
    for (final c in cases.entries) {
      expect(thresholdBand(c.key.toDouble()), c.value);
    }
    expect(() => thresholdBand(double.nan), throwsArgumentError);
  });
  test('PTA3 requires exact frequencies, and reports arithmetic evidence', () {
    final r = engine.evaluate(input());
    expect(r.observations.firstWhere((o) => o.ruleId == 'D02').evidence,
        contains('30.0 dB HL'));
    final partial = engine.evaluate(input(left: {500: 20, 2000: 40}));
    expect(partial.observations.firstWhere((o) => o.ruleId == 'D02').kind,
        ObservationKind.missing);
    expect(partial.observations.firstWhere((o) => o.ruleId == 'D02').evidence,
        contains('1000'));
  });
  test('An absent ear is not classified and missing pairs are disclosed', () {
    final r = engine.evaluate(input(right: {}));
    expect(r.observations.where((o) => o.ruleId == 'D01').length, 1);
    expect(r.observations.firstWhere((o) => o.ruleId == 'D03').kind,
        ObservationKind.missing);
    expect(
        r.observations
            .any((o) => o.title == 'Right: incomplete frequency coverage'),
        isTrue);
  });
  test('Comparison direction and heuristic boundary are explicit', () {
    final r =
        engine.evaluate(input(left: {250: 10, 500: 10, 4000: 30, 8000: 30}));
    final shape = r.observations.firstWhere((o) => o.ruleId == 'H01');
    expect(shape.explanation, startsWith('Higher'));
    expect(shape.explanation, contains('app heuristic'));
    expect(r.observations.firstWhere((o) => o.ruleId == 'D03').evidence,
        contains('4000 Hz: L − R = 20 dB'));
    expect(r.observations.firstWhere((o) => o.ruleId == 'Q02').evidence,
        contains('1000'));
    final below =
        engine.evaluate(input(left: {250: 10, 500: 10, 4000: 29, 8000: 29}));
    expect(below.observations.firstWhere((o) => o.ruleId == 'H01').explanation,
        contains('not triggered'));
  });
  test('No diagnostic classification of type or automated referral is emitted',
      () {
    final r = engine.evaluate(input());
    expect(r.observations.last.ruleId, 'L01');
    expect(r.toText(), contains('Not a diagnosis'));
    expect(r.toText(), contains('Rules 1.0.0'));
    expect(
        r.observations
            .where((o) => o.ruleId == 'D01')
            .every((o) => o.source == ashaSource),
        isTrue);
    expect(r.toText(), engine.evaluate(input()).toText());
  });
  test('CSV preserves missing thresholds and accepts arbitrary row ordering',
      () {
    final p = parseAudiogramCsv(
        'frequency_hz,left_dbhl,right_dbhl\n1000,30,\n250,,10');
    expect(p.left, {1000: 30});
    expect(p.right, {250: 10});
    expect(p.left.containsKey(250), isFalse);
  });
  test('CSV rejects ambiguity instead of coercing input', () {
    for (final csv in [
      'frequency_hz,left_dbfs,right_dbfs\n250,-30,-30',
      'frequency_hz,left_dbhl,right_dbhl\n250,NR,10',
      'frequency_hz,left_dbhl,right_dbhl\n250,NaN,10',
      'frequency_hz,left_dbhl,right_dbhl\n250,Infinity,10',
      'frequency_hz,left_dbhl,right_dbhl\n250,10,20\n250,30,40',
      'frequency_hz,left_dbhl,right_dbhl\n256,10,20',
      'frequency_hz,left_dbhl,right_dbhl\n250,10',
      'frequency_hz,left_dbhl,right_dbhl\n250,120.1,10'
    ]) {
      expect(() => parseAudiogramCsv(csv), throwsFormatException);
    }
  });
  test('Inputs cannot be changed after construction', () {
    final values = <int, double>{500: 10};
    final data = input(left: values);
    values[500] = 99;
    expect(data.left[500], 10);
    expect(() => data.left[500] = 30, throwsUnsupportedError);
  });
}
