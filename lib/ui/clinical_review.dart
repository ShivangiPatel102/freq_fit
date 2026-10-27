import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/clinical_rules.dart';
import 'components.dart';

const blankAudiogram =
    'frequency_hz,left_dbhl,right_dbhl\n250,,\n500,,\n1000,,\n2000,,\n4000,,\n8000,,';
const exampleAudiogram =
    'frequency_hz,left_dbhl,right_dbhl\n250,15,10\n500,20,15\n1000,30,20\n2000,40,25\n4000,55,30\n8000,60,35';

class ClinicalReview extends StatefulWidget {
  const ClinicalReview({super.key});
  @override
  State<ClinicalReview> createState() => _ClinicalReviewState();
}

class _ClinicalReviewState extends State<ClinicalReview> {
  final resultsKey = GlobalKey();
  final csv = TextEditingController(text: blankAudiogram);
  final age = TextEditingController();
  final source = TextEditingController();
  bool calibrated = false;
  bool reliable = false;
  ClinicalReport? report;
  AudiogramInput? analyzed;
  String? error;
  void invalidate() => setState(() {
        report = null;
        analyzed = null;
        error = null;
      });
  @override
  void dispose() {
    csv.dispose();
    age.dispose();
    source.dispose();
    super.dispose();
  }

  void analyze() {
    try {
      final parsedAge = int.tryParse(age.text.trim());
      if (parsedAge == null) {
        throw const FormatException('Enter a whole-number adult age.');
      }
      final points = parseAudiogramCsv(csv.text);
      final input = AudiogramInput(
          left: points.left,
          right: points.right,
          unit: MeasurementUnit.dbHL,
          calibrated: calibrated,
          reliabilityConfirmed: reliable,
          age: parsedAge,
          source: source.text.trim());
      setState(() {
        analyzed = input;
        report = ClinicalRulesEngine().evaluate(input);
        error = null;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final target = resultsKey.currentContext;
        if (mounted && target != null) {
          Scrollable.ensureVisible(target,
              duration: const Duration(milliseconds: 300), alignment: 0);
        }
      });
    } on FormatException catch (e) {
      setState(() {
        error = e.message;
        report = null;
        analyzed = null;
      });
    }
  }

  Future<void> copyReport() async {
    final input = analyzed!;
    final text =
        'Source: ${input.source}\nAdult age: ${input.age}\nUnits: dB HL\nCalibration confirmed by user: ${input.calibrated}\nReliability confirmed by user: ${input.reliabilityConfirmed}\n\n${report!.toText()}';
    try {
      await Clipboard.setData(ClipboardData(text: text));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Clinical review report copied')));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Clipboard unavailable. Please enable access and retry.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: label('Clinical observations',
                size: 18, weight: FontWeight.w600),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: pill('RULES $ruleVersion'))
            ]),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          pill('FOR CLINICIAN REVIEW'),
                          const SizedBox(height: 18),
                          label('From measurements to observations.',
                              size: 30, weight: FontWeight.w600),
                          const SizedBox(height: 12),
                          const Text(
                              'Review an external adult air-conduction audiogram using transparent calculations. Each observation includes its evidence and rule. No machine learning or image interpretation.',
                              style: TextStyle(
                                  fontSize: 16, height: 1.5, color: muted)),
                          const SizedBox(height: 22),
                          Panel(
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                const Icon(Icons.info_outline, color: purple),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: label(
                                        'This prototype has not been clinically validated. It does not diagnose, recommend treatment, or rule out disease. FreqFit’s own dBFS recordings are not eligible. User confirmations do not independently verify calibration or test quality.',
                                        size: 14,
                                        color: muted))
                              ])),
                          const SizedBox(height: 24),
                          Panel(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                heading('1. Identify the measurements'),
                                const SizedBox(height: 18),
                                TextField(
                                    controller: source,
                                    maxLength: 120,
                                    onChanged: (_) => invalidate(),
                                    decoration: const InputDecoration(
                                        labelText:
                                            'Measurement source / equipment reference',
                                        hintText:
                                            'Use a de-identified reference, not a patient name')),
                                const SizedBox(height: 12),
                                TextField(
                                    controller: age,
                                    keyboardType: TextInputType.number,
                                    onChanged: (_) => invalidate(),
                                    decoration: const InputDecoration(
                                        labelText: 'Adult age (years)',
                                        hintText: '18–120')),
                                const SizedBox(height: 12),
                                CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                        'I confirm these are calibrated dB HL air-conduction thresholds.'),
                                    subtitle: const Text(
                                        'Not app volume, dBFS, dB SPL, or an estimated conversion.'),
                                    value: calibrated,
                                    onChanged: (v) {
                                      invalidate();
                                      setState(() => calibrated = v!);
                                    }),
                                CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: const Text(
                                        'A clinician has reviewed measurement reliability.'),
                                    subtitle: const Text(
                                        'Including the procedure, environment, and masking where indicated.'),
                                    value: reliable,
                                    onChanged: (v) {
                                      invalidate();
                                      setState(() => reliable = v!);
                                    }),
                              ])),
                          const SizedBox(height: 20),
                          Panel(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                heading('2. Paste numeric thresholds'),
                                const SizedBox(height: 12),
                                label(
                                    'CSV columns: frequency_hz,left_dbhl,right_dbhl. Leave missing and no-response values blank. Never replace a no-response result with the instrument’s maximum level.',
                                    size: 14,
                                    color: muted),
                                const SizedBox(height: 14),
                                TextField(
                                    controller: csv,
                                    minLines: 8,
                                    maxLines: 14,
                                    maxLength: 2000,
                                    onChanged: (_) => invalidate(),
                                    style: const TextStyle(
                                        fontFamily: 'monospace', fontSize: 13),
                                    decoration: const InputDecoration(
                                        labelText: 'Audiogram CSV',
                                        alignLabelWithHint: true)),
                                const SizedBox(height: 8),
                                label(
                                    'Whole-number thresholds: −10 to 120 dB HL. Supported Hz: ${clinicalFrequencies.join(', ')}.',
                                    size: 12,
                                    color: muted),
                                const SizedBox(height: 14),
                                Wrap(spacing: 12, runSpacing: 12, children: [
                                  FilledButton.icon(
                                      onPressed: analyze,
                                      icon: const Icon(Icons.manage_search,
                                          size: 18),
                                      label:
                                          const Text('Generate observations')),
                                  OutlinedButton(
                                      onPressed: () {
                                        csv.text = exampleAudiogram;
                                        age.text = '45';
                                        source.text =
                                            'SYNTHETIC EXAMPLE — not a patient measurement';
                                        calibrated = false;
                                        reliable = false;
                                        invalidate();
                                      },
                                      child:
                                          const Text('Load synthetic example'))
                                ]),
                                if (error != null)
                                  Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Text(error!,
                                          style: const TextStyle(
                                              color: Color(0xFFB26060)))),
                              ])),
                          if (report != null) ...[
                            const SizedBox(height: 30),
                            Container(
                                key: resultsKey,
                                child: heading('3. Observations for review')),
                            const SizedBox(height: 10),
                            label(
                                'Source: ${analyzed!.source.isEmpty ? 'Not provided' : analyzed!.source} · Age ${analyzed!.age} · dB HL',
                                size: 13,
                                color: muted),
                            const SizedBox(height: 16),
                            if (!report!.blocked) ...[
                              Panel(child: ClinicalPlot(input: analyzed!)),
                              const SizedBox(height: 18)
                            ],
                            ...report!.observations.map(observationCard),
                            const SizedBox(height: 8),
                            FilledButton.icon(
                                onPressed: copyReport,
                                icon: const Icon(Icons.copy, size: 17),
                                label: const Text('Copy review report')),
                            const SizedBox(height: 14),
                            label(
                                'Rules $ruleVersion · Findings require clinician verification. This review is not saved to session history; copy it before leaving. Changing any input clears the report.',
                                size: 12,
                                color: muted),
                          ],
                          const SizedBox(height: 26),
                          label(
                              'Sources: ASHA Hearing Loss in Adults (ASHA/Clark threshold bands and assessment context). Formulas, input gates and the H01 comparison heuristic are FreqFit conventions, defined below. No automated referral criterion is applied.',
                              size: 12,
                              color: muted),
                          const SizedBox(height: 12),
                          ExpansionTile(
                              title: const Text(
                                  'Rule definitions and limitations'),
                              tilePadding: EdgeInsets.zero,
                              children: const [
                                Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Text(
                                        'G01–G07: require dB HL, calibration and reliability confirmation, age 18–120, a measurement source, numeric data, and valid values.\n\nQ01/Q02: report missing core frequencies and missing left/right pairs. Blanks never mean normal hearing.\n\nD01: ASHA/Clark individual-threshold bands: −10–15 normal range; 16–25 slight; 26–40 mild; 41–55 moderate; 56–70 moderately severe; 71–90 severe; 91+ profound (dB HL).\n\nD02: PTA3 = (500 + 1000 + 2000 Hz thresholds) / 3, separately per ear. This is a numerical summary; no overall severity label is assigned.\n\nD03: paired difference = left − right in dB. No symmetry, referral, or disease conclusion.\n\nH01: compare the mean of 4000/8000 Hz with the mean of 250/500 Hz. An absolute difference of at least 20 dB triggers a descriptive flag. This is an unvalidated app heuristic, not a clinical criterion.\n\nL01: air-conduction-only data cannot establish hearing-loss type or cause. This prototype has no clinical validation.',
                                        style: TextStyle(
                                            fontSize: 14,
                                            height: 1.5,
                                            color: muted))),
                              ]),
                          const SizedBox(height: 8),
                          SelectableText(ashaSource,
                              style:
                                  const TextStyle(fontSize: 12, color: purple)),
                          const SizedBox(height: 25),
                        ])))),
      );
  Widget observationCard(ClinicalObservation o) {
    final color = switch (o.kind) {
      ObservationKind.blocked => const Color(0xFFB26060),
      ObservationKind.missing => const Color(0xFFA5783D),
      ObservationKind.finding => purple,
      ObservationKind.limitation => muted
    };
    return Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Panel(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                pill(o.ruleId, color: color),
                label(o.title, size: 18, weight: FontWeight.w600)
              ]),
          const SizedBox(height: 14),
          Text(o.evidence, style: const TextStyle(fontSize: 15, height: 1.55)),
          const SizedBox(height: 10),
          Text(o.explanation,
              style: const TextStyle(fontSize: 14, height: 1.5, color: muted)),
          const SizedBox(height: 12),
          SelectableText('Source: ${o.source}',
              style: const TextStyle(fontSize: 11, color: muted)),
        ])));
  }
}

class ClinicalPlot extends StatelessWidget {
  final AudiogramInput input;
  const ClinicalPlot({super.key, required this.input});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        heading('Imported air-conduction thresholds'),
        const SizedBox(height: 10),
        label('× Left · ○ Right · dB HL increases downward',
            size: 13, color: muted),
        const SizedBox(height: 20),
        SizedBox(
            height: 270,
            width: double.infinity,
            child: ExcludeSemantics(
                child: CustomPaint(painter: _ClinicalPainter(input)))),
        const SizedBox(height: 18),
        label('Numeric values (Hz / dB HL)', size: 14, weight: FontWeight.w600),
        const SizedBox(height: 10),
        const Row(children: [
          Expanded(child: Text('Hz')),
          Expanded(child: Text('Left')),
          Expanded(child: Text('Right'))
        ]),
        ...clinicalFrequencies
            .where(
                (f) => input.left.containsKey(f) || input.right.containsKey(f))
            .map((f) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(children: [
                  Expanded(child: Text('$f')),
                  Expanded(
                      child: Text(
                          input.left[f]?.toStringAsFixed(0) ?? 'Not recorded')),
                  Expanded(
                      child: Text(
                          input.right[f]?.toStringAsFixed(0) ?? 'Not recorded'))
                ]))),
      ]);
}

class _ClinicalPainter extends CustomPainter {
  final AudiogramInput input;
  _ClinicalPainter(this.input);
  @override
  void paint(Canvas c, Size size) {
    final width = size.width - 50, height = size.height - 25;
    double x(int f) => 32 + log(f / 125) / log(8000 / 125) * width;
    double y(double db) => (db + 10) / 130 * height;
    void text(String s, Offset p) {
      final t = TextPainter(
          text: TextSpan(
              text: s, style: const TextStyle(fontSize: 10, color: muted)),
          textDirection: TextDirection.ltr)
        ..layout();
      t.paint(c, p);
    }

    for (var db = -10; db <= 120; db += 10) {
      c.drawLine(Offset(32, y(db.toDouble())),
          Offset(32 + width, y(db.toDouble())), Paint()..color = line);
      if (db % 20 == 0) text('$db', Offset(0, y(db.toDouble()) - 5));
    }
    for (final f in [125, 250, 500, 1000, 2000, 4000, 8000]) {
      c.drawLine(Offset(x(f), 0), Offset(x(f), height), Paint()..color = line);
      text(f >= 1000 ? '${f ~/ 1000}k' : '$f', Offset(x(f) - 8, height + 10));
    }
    for (final ear in [
      (input.left, purple, true),
      (input.right, const Color(0xFFDC8A74), false)
    ]) {
      final paint = Paint()
        ..color = ear.$2
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      // Points are deliberately unconnected: missing frequencies are not interpolated.
      for (final point in ear.$1.entries) {
        final p = Offset(x(point.key), y(point.value));
        if (ear.$3) {
          c.drawLine(p - const Offset(4, 4), p + const Offset(4, 4), paint);
          c.drawLine(p - const Offset(4, -4), p + const Offset(4, -4), paint);
        } else {
          c.drawCircle(p, 4, paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ClinicalPainter oldDelegate) =>
      input != oldDelegate.input;
}
