/// Deterministic observations for clinician review, never autonomous diagnosis.
library;

const clinicalFrequencies = [
  125,
  250,
  500,
  750,
  1000,
  1500,
  2000,
  3000,
  4000,
  6000,
  8000
];
const ruleVersion = '1.0.0';
const ashaSource =
    'https://www.asha.org/practice-portal/clinical-topics/hearing-loss/';
const ruleDocumentation = 'FreqFit numerical conventions v1.0.0';

enum MeasurementUnit { dbHL, dbFS, unknown }

enum ObservationKind { blocked, missing, finding, limitation }

class AudiogramInput {
  final Map<int, double> left;
  final Map<int, double> right;
  final MeasurementUnit unit;
  final bool calibrated;
  final bool reliabilityConfirmed;
  final int age;
  final String source;
  AudiogramInput(
      {required Map<int, double> left,
      required Map<int, double> right,
      required this.unit,
      required this.calibrated,
      required this.reliabilityConfirmed,
      required this.age,
      required this.source})
      : left = Map.unmodifiable(left),
        right = Map.unmodifiable(right);
}

class ClinicalObservation {
  final String ruleId;
  final String title;
  final String evidence;
  final String explanation;
  final ObservationKind kind;
  final String source;
  const ClinicalObservation(
      this.ruleId, this.title, this.evidence, this.explanation, this.kind,
      {this.source = ruleDocumentation});
}

class ClinicalReport {
  final List<ClinicalObservation> observations;
  const ClinicalReport(this.observations);
  bool get blocked =>
      observations.any((o) => o.kind == ObservationKind.blocked);
  String toText() =>
      'FreqFit · Clinical observations for review\nRules $ruleVersion · Not a diagnosis\n\n${observations.map((o) => '[${o.ruleId}] ${o.title}\nEvidence: ${o.evidence}\n${o.explanation}\nSource: ${o.source}').join('\n\n')}';
}

/// ASHA/Clark bands applied to individual, whole-number dB HL thresholds.
/// PTA averages are reported numerically, not assigned an overall diagnosis.
String thresholdBand(double value) {
  if (!value.isFinite ||
      value < -10 ||
      value > 120 ||
      value != value.roundToDouble()) {
    throw ArgumentError(
        'A threshold must be a whole number between -10 and 120 dB HL.');
  }
  if (value <= 15) return 'Normal range';
  if (value <= 25) return 'Slight';
  if (value <= 40) return 'Mild';
  if (value <= 55) return 'Moderate';
  if (value <= 70) return 'Moderately severe';
  if (value <= 90) return 'Severe';
  return 'Profound';
}

class ClinicalRulesEngine {
  ClinicalReport evaluate(AudiogramInput input) {
    final out = <ClinicalObservation>[];
    void gate(String id, String title, String evidence, String why) => out.add(
        ClinicalObservation(id, title, evidence, why, ObservationKind.blocked));
    if (input.unit != MeasurementUnit.dbHL) {
      gate(
          'G01',
          'Clinical interpretation withheld',
          'Unit: ${input.unit.name}.',
          'Only externally measured, calibrated dB HL thresholds are supported. Digital dBFS values cannot be converted by this engine.');
    }
    if (!input.calibrated) {
      gate(
          'G02',
          'Calibration is unconfirmed',
          'Calibration confirmation: absent.',
          'Confirm the source used calibrated audiometric equipment and appropriate transducers. A checkbox does not independently verify equipment.');
    }
    if (!input.reliabilityConfirmed) {
      gate(
          'G03',
          'Measurement reliability is unconfirmed',
          'Reliability confirmation: absent.',
          'A clinician must review threshold procedure, test conditions, and masking where indicated before interpreting values.');
    }
    if (input.age < 18 || input.age > 120) {
      gate('G04', 'Outside supported adult age range', 'Age: ${input.age}.',
          'This version supports adults aged 18–120 only.');
    }
    if (input.source.trim().isEmpty) {
      gate(
          'G05',
          'Measurement source is missing',
          'No source or equipment reference entered.',
          'Record where these thresholds came from.');
    }
    if (input.left.isEmpty && input.right.isEmpty) {
      gate(
          'G06',
          'No measured thresholds',
          'Both ears have no numeric thresholds.',
          'Enter at least one measured threshold; blanks are never assumed to mean normal hearing.');
    }
    for (final ear in [('Left', input.left), ('Right', input.right)]) {
      for (final p in ear.$2.entries) {
        if (!clinicalFrequencies.contains(p.key) ||
            !p.value.isFinite ||
            p.value < -10 ||
            p.value > 120 ||
            p.value != p.value.roundToDouble()) {
          gate(
              'G07',
              'Invalid threshold data',
              '${ear.$1}: ${p.key} Hz → ${p.value}.',
              'Use supported frequencies and finite, whole-number thresholds from −10 to 120 dB HL. This range is an input bound, not an instrument output claim.');
        }
      }
    }
    if (out.isNotEmpty) return ClinicalReport(List.unmodifiable(out));
    for (final ear in [('Left', input.left), ('Right', input.right)]) {
      final name = ear.$1;
      final points = ear.$2;
      final core = [250, 500, 1000, 2000, 4000, 8000];
      final missing = core.where((f) => !points.containsKey(f)).toList();
      if (missing.isNotEmpty) {
        out.add(ClinicalObservation(
            'Q01',
            '$name: incomplete frequency coverage',
            'Missing core frequencies: ${missing.join(', ')} Hz.',
            'Any available values are described below. No inference is made at missing frequencies; absence may include an unrecorded no-response result.',
            ObservationKind.missing));
      }
      if (points.isEmpty) continue;
      final ordered = points.keys.toList()..sort();
      out.add(ClinicalObservation(
          'D01',
          '$name: threshold bands by frequency',
          ordered
              .map((f) =>
                  '$f Hz: ${points[f]!.toStringAsFixed(0)} dB HL (${thresholdBand(points[f]!)})')
              .join('; '),
          'ASHA/Clark descriptive bands apply to individual thresholds. These are not a diagnosis or a single severity grade for the ear.',
          ObservationKind.finding,
          source: ashaSource));
      const pta = [500, 1000, 2000];
      if (pta.every(points.containsKey)) {
        final mean = pta.map((f) => points[f]!).reduce((a, b) => a + b) / 3;
        out.add(ClinicalObservation(
            'D02',
            '$name: three-frequency average',
            '(500 Hz ${points[500]}, 1000 Hz ${points[1000]}, 2000 Hz ${points[2000]}) / 3 = ${mean.toStringAsFixed(1)} dB HL.',
            'Arithmetic PTA3 for this report. It does not describe all frequencies or determine hearing-loss type.',
            ObservationKind.finding));
      } else {
        out.add(ClinicalObservation(
            'D02',
            '$name: PTA3 not calculated',
            'Missing: ${pta.where((f) => !points.containsKey(f)).join(', ')} Hz.',
            'All of 500, 1000 and 2000 Hz are required. No interpolation or averaging of a smaller subset.',
            ObservationKind.missing));
      }
      const shape = [250, 500, 4000, 8000];
      if (shape.every(points.containsKey)) {
        final low = (points[250]! + points[500]!) / 2;
        final high = (points[4000]! + points[8000]!) / 2;
        final delta = high - low;
        out.add(ClinicalObservation(
            'H01',
            '$name: low/high frequency comparison',
            'Mean at 250/500 Hz: ${low.toStringAsFixed(1)}; at 4000/8000 Hz: ${high.toStringAsFixed(1)} dB HL; high − low = ${delta.toStringAsFixed(1)} dB.',
            delta.abs() >= 20
                ? '${delta > 0 ? 'Higher' : 'Lower'} recorded thresholds at the high-frequency pair. The 20 dB flag is an app heuristic, not a validated diagnostic criterion or a statement of cause.'
                : 'The app’s 20 dB low/high difference flag is not triggered. This does not establish a flat configuration or exclude hearing loss.',
            ObservationKind.finding));
      } else {
        out.add(ClinicalObservation(
            'H01',
            '$name: pattern comparison unavailable',
            'Required: 250, 500, 4000 and 8000 Hz.',
            'No shape is inferred from an incomplete low/high comparison.',
            ObservationKind.missing));
      }
    }
    final paired = clinicalFrequencies
        .where((f) => input.left.containsKey(f) && input.right.containsKey(f))
        .toList();
    if (paired.isEmpty) {
      out.add(const ClinicalObservation(
          'D03',
          'Ear comparison unavailable',
          'No frequencies have thresholds for both ears.',
          'Paired frequencies are required. No symmetry conclusion is possible.',
          ObservationKind.missing));
    } else {
      out.add(ClinicalObservation(
          'D03',
          'Ear-to-ear differences',
          paired.map((f) {
            final delta = input.left[f]! - input.right[f]!;
            return '$f Hz: L − R = ${delta.toStringAsFixed(0)} dB';
          }).join('; '),
          'Positive values mean a higher recorded left-ear threshold; negative values mean a higher right-ear threshold. These differences alone do not determine a referral or hearing-loss type.',
          ObservationKind.finding));
      final missingPairs = [500, 1000, 2000, 4000, 8000]
          .where((f) => !paired.contains(f))
          .toList();
      if (missingPairs.isNotEmpty) {
        out.add(ClinicalObservation(
            'Q02',
            'Ear comparison has incomplete coverage',
            'Missing pairs: ${missingPairs.join(', ')} Hz.',
            'Available pairs are reported, but symmetry across the full range cannot be concluded.',
            ObservationKind.missing));
      }
    }
    out.add(const ClinicalObservation(
        'L01',
        'Hearing-loss type and cause are not determined',
        'Input contains air-conduction thresholds only.',
        'Interpret with history, otoscopy, bone-conduction thresholds, masking, speech results and other tests as indicated. This engine cannot distinguish conductive, sensorineural or mixed loss from these inputs.',
        ObservationKind.limitation,
        source: ashaSource));
    return ClinicalReport(List.unmodifiable(out));
  }
}

/// Strict numeric CSV input. No screenshots, inferred units, or silent coercion.
({Map<int, double> left, Map<int, double> right}) parseAudiogramCsv(
    String csv) {
  final rows = csv.trim().replaceFirst('\uFEFF', '').split(RegExp(r'\r?\n'));
  if (rows.isEmpty ||
      rows.first.trim().toLowerCase() != 'frequency_hz,left_dbhl,right_dbhl') {
    throw const FormatException(
        'Use the header frequency_hz,left_dbhl,right_dbhl. dBFS imports are not supported.');
  }
  if (rows.length > clinicalFrequencies.length + 1) {
    throw const FormatException('Too many frequency rows.');
  }
  final left = <int, double>{}, right = <int, double>{};
  final seen = <int>{};
  for (var i = 1; i < rows.length; i++) {
    if (rows[i].trim().isEmpty) continue;
    final cells = rows[i].split(',').map((v) => v.trim()).toList();
    if (cells.length != 3) {
      throw FormatException(
          'Row ${i + 1}: expected three comma-separated fields.');
    }
    final f = int.tryParse(cells[0]);
    if (f == null || !clinicalFrequencies.contains(f)) {
      throw FormatException('Row ${i + 1}: unsupported frequency.');
    }
    if (!seen.add(f)) {
      throw FormatException('Row ${i + 1}: duplicate frequency $f Hz.');
    }
    for (var ear = 1; ear <= 2; ear++) {
      if (cells[ear].isEmpty) continue;
      final value = double.tryParse(cells[ear]);
      if (value == null ||
          !value.isFinite ||
          value < -10 ||
          value > 120 ||
          value != value.roundToDouble()) {
        throw FormatException(
            'Row ${i + 1}: thresholds must be whole numbers from −10 to 120 dB HL. Leave missing or no-response values blank; never enter an output limit as a measured threshold.');
      }
      (ear == 1 ? left : right)[f] = value;
    }
  }
  return (left: left, right: right);
}
