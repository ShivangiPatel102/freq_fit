import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';

/// A one-second, ear-isolated pulse with a 20 ms fade to avoid clicks.
/// dBFS is relative digital amplitude, never a calibrated dB HL measurement.
Uint8List toneWave(int frequency, double dbfs, bool left) {
  const rate = 48000;
  const frames = rate;
  final data = ByteData(44 + frames * 4);
  void label(int offset, String text) {
    for (var i = 0; i < text.length; i++) {
      data.setUint8(offset + i, text.codeUnitAt(i));
    }
  }

  label(0, 'RIFF');
  data.setUint32(4, 36 + frames * 4, Endian.little);
  label(8, 'WAVE');
  label(12, 'fmt ');
  data.setUint32(16, 16, Endian.little);
  data.setUint16(20, 1, Endian.little);
  data.setUint16(22, 2, Endian.little);
  data.setUint32(24, rate, Endian.little);
  data.setUint32(28, rate * 4, Endian.little);
  data.setUint16(32, 4, Endian.little);
  data.setUint16(34, 16, Endian.little);
  label(36, 'data');
  data.setUint32(40, frames * 4, Endian.little);
  final amplitude = pow(10, dbfs.clamp(-60, -12) / 20) * 32767;
  for (var i = 0; i < frames; i++) {
    final fade = min(1.0, min(i / 960, (frames - 1 - i) / 960));
    final sample =
        (sin(2 * pi * frequency * i / rate) * amplitude * fade).round();
    data.setInt16(44 + i * 4, left ? sample : 0, Endian.little);
    data.setInt16(46 + i * 4, left ? 0 : sample, Endian.little);
  }
  return data.buffer.asUint8List();
}

class TonePlayer {
  AudioPlayer? _instance;
  AudioPlayer get _player => _instance ??= AudioPlayer();
  Future<void> play(int frequency, double dbfs, bool left) async {
    await _player.stop();
    await _player.play(
        BytesSource(toneWave(frequency, dbfs, left), mimeType: 'audio/wav'));
  }

  Future<void> stop() async {
    await _instance?.stop();
  }

  Future<void> dispose() async {
    await _instance?.dispose();
  }
}
