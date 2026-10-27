import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:freq_fit/core/session.dart';
import 'package:freq_fit/core/tone.dart';

void main() {
  test('Sessions survive reload, retain both ears, and can be deleted',
      () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = SessionStore(prefs);
    await store.save(HearingSession(
        id: '1',
        name: 'Morning check',
        date: DateTime(2026, 10, 27),
        levels: {'L250': -45, 'R250': -42},
        notes: 'Quiet room'));
    final restored = SessionStore(prefs);
    expect(restored.sessions.single.levels, {'L250': -45, 'R250': -42});
    expect(restored.sessions.single.notes, 'Quiet room');
    await restored.delete('1');
    expect(SessionStore(prefs).sessions, isEmpty);
  });
  test('Corrupt history is preserved rather than overwritten', () async {
    SharedPreferences.setMockInitialValues({'freqfit.sessions.v2': 'broken'});
    final prefs = await SharedPreferences.getInstance();
    final store = SessionStore(prefs);
    expect(store.error, isNotNull);
    await expectLater(
        store.save(HearingSession(
            id: '1', name: 'Check', date: DateTime.now(), levels: {})),
        throwsStateError);
    expect(prefs.getString('freqfit.sessions.v2'), 'broken');
  });
  test('WAV has isolated channels, bounded amplitude, and click-free edges',
      () {
    for (final left in [true, false]) {
      final wave = toneWave(1000, -12, left);
      final data = ByteData.sublistView(wave);
      expect(String.fromCharCodes(wave.take(4)), 'RIFF');
      expect(data.getUint32(24, Endian.little), 48000);
      var peak = 0;
      for (var i = 0; i < 48000; i++) {
        expect(data.getInt16(44 + i * 4 + (left ? 2 : 0), Endian.little), 0);
        final active =
            data.getInt16(44 + i * 4 + (left ? 0 : 2), Endian.little).abs();
        if (active > peak) peak = active;
      }
      expect(peak, inInclusiveRange(8200, 8232));
      expect(data.getInt16(44 + (left ? 0 : 2), Endian.little), 0);
      expect(data.getInt16(44 + 47999 * 4 + (left ? 0 : 2), Endian.little), 0);
    }
  });
}
