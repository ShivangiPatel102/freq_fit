import 'dart:math';
import 'package:flutter/material.dart';
import '../core/session.dart';

const ink = Color(0xFF252940);
const muted = Color(0xFF7C8296);
const purple = Color(0xFF5462D6);
const line = Color(0xFFE9EBF2);

Widget label(String text,
        {double size = 14,
        Color color = ink,
        FontWeight weight = FontWeight.w400}) =>
    Text(text,
        style: TextStyle(fontSize: size, color: color, fontWeight: weight));
Widget heading(String text) => label(text, size: 22, weight: FontWeight.w600);
Widget pill(String text, {Color color = purple}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
        color: color.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(6)),
    child: label(text, size: 12, color: color, weight: FontWeight.w600));

class Panel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const Panel(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(26)});
  @override
  Widget build(BuildContext context) => Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: line),
          borderRadius: BorderRadius.circular(18)),
      child: Padding(padding: padding, child: child));
}

class SoundArt extends StatelessWidget {
  const SoundArt({super.key});
  @override
  Widget build(BuildContext context) => CustomPaint(painter: _SoundPainter());
}

class _SoundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * .55, size.height * .5);
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
          center,
          46 + i * 24,
          Paint()
            ..color = purple.withValues(alpha: .055)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5);
    }
    for (var i = 0; i < 37; i++) {
      final x = size.width * .1 + i * size.width * .023;
      final height =
          10 + 83 * pow(sin(i * .34), 2) * exp(-pow((i - 18) / 16, 2));
      canvas.drawLine(
          Offset(x, center.dy - height / 2),
          Offset(x, center.dy + height / 2),
          Paint()
            ..strokeWidth = 5
            ..strokeCap = StrokeCap.round
            ..color = Color.lerp(
                const Color(0xFF8F9AEC), const Color(0xFF535ED0), i / 37)!);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SessionChart extends StatelessWidget {
  final Map<String, double> levels;
  const SessionChart({super.key, required this.levels});
  @override
  Widget build(BuildContext context) => Column(children: [
        Wrap(
            spacing: 20,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              label('Recorded response levels',
                  size: 16, weight: FontWeight.w600),
              label('× Left', color: purple),
              label('○ Right', color: const Color(0xFFDC8A74)),
            ]),
        const SizedBox(height: 20),
        SizedBox(
            height: 240,
            width: double.infinity,
            child: CustomPaint(painter: _ChartPainter(levels))),
        const SizedBox(height: 8),
        label('Frequency (Hz)  ·  Digital level (dBFS)',
            size: 12, color: muted),
        const SizedBox(height: 14),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: label('View response values', size: 14, color: purple),
          children: [
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(children: [
                  Expanded(child: Text('Hz')),
                  Expanded(child: Text('Left dBFS')),
                  Expanded(child: Text('Right dBFS'))
                ])),
            for (final f in frequencies)
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(children: [
                    Expanded(child: Text('$f')),
                    Expanded(
                        child: Text(levels['L$f']?.toStringAsFixed(0) ??
                            'Not recorded')),
                    Expanded(
                        child: Text(levels['R$f']?.toStringAsFixed(0) ??
                            'Not recorded'))
                  ])),
          ],
        ),
      ]);
}

class _ChartPainter extends CustomPainter {
  final Map<String, double> levels;
  _ChartPainter(this.levels);
  void text(Canvas c, String value, Offset p) {
    final t = TextPainter(
        text: TextSpan(
            text: value, style: const TextStyle(fontSize: 11, color: muted)),
        textDirection: TextDirection.ltr)
      ..layout();
    t.paint(c, p);
  }

  @override
  void paint(Canvas c, Size size) {
    const left = 35.0;
    final w = size.width - 55;
    final h = size.height - 28;
    for (var i = 0; i <= 4; i++) {
      final y = i * h / 4;
      c.drawLine(Offset(left, y), Offset(left + w, y), Paint()..color = line);
      text(c, '${-60 + i * 12}', Offset(0, y));
    }
    for (var i = 0; i < frequencies.length; i++) {
      final x = left + w * i / 5;
      c.drawLine(Offset(x, 0), Offset(x, h), Paint()..color = line);
      text(
          c,
          frequencies[i] >= 1000
              ? '${frequencies[i] ~/ 1000}k'
              : '${frequencies[i]}',
          Offset(x - 8, h + 12));
    }
    for (final ear in ['L', 'R']) {
      final paint = Paint()
        ..color = ear == 'L' ? purple : const Color(0xFFDC8A74)
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke;
      Offset? previous;
      for (var i = 0; i < frequencies.length; i++) {
        final level = levels['$ear${frequencies[i]}'];
        if (level == null) {
          previous = null;
          continue;
        }
        final p = Offset(left + w * i / 5, (level + 60) / 48 * h);
        if (previous != null) c.drawLine(previous, p, paint);
        if (ear == 'R') {
          c.drawCircle(p, 4, paint);
        } else {
          c.drawLine(p - const Offset(4, 4), p + const Offset(4, 4), paint);
          c.drawLine(p - const Offset(4, -4), p + const Offset(4, -4), paint);
        }
        previous = p;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) => true;
}
