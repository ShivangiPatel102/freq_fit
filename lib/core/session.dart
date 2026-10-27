import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const frequencies = [250, 500, 1000, 2000, 4000, 8000];

class HearingSession {
  final String id;
  final String name;
  final DateTime date;
  final Map<String, double> levels;
  final String notes;
  HearingSession(
      {required this.id,
      required this.name,
      required this.date,
      required this.levels,
      this.notes = ''});
  bool get complete => levels.length == 12;
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'date': date.toIso8601String(),
        'levels': levels,
        'notes': notes
      };
  factory HearingSession.fromJson(Map<String, dynamic> json) => HearingSession(
        id: json['id'] as String,
        name: json['name'] as String,
        date: DateTime.parse(json['date'] as String),
        levels: (json['levels'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toDouble())),
        notes: json['notes'] as String? ?? '',
      );
}

class SessionStore extends ChangeNotifier {
  final SharedPreferences preferences;
  List<HearingSession> sessions = [];
  String? error;
  SessionStore(this.preferences) {
    try {
      final raw = preferences.getString('freqfit.sessions.v2');
      if (raw != null) {
        sessions = (jsonDecode(raw) as List)
            .map((e) => HearingSession.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    } catch (_) {
      error =
          'Saved history could not be read. Your stored data has been left untouched.';
    }
  }
  Future<void> save(HearingSession session) async {
    if (error != null) throw StateError(error!);
    final next = [session, ...sessions.where((s) => s.id != session.id)];
    final saved = await preferences.setString('freqfit.sessions.v2',
        jsonEncode(next.map((s) => s.toJson()).toList()));
    if (!saved) {
      throw StateError('Could not save this session. Please try again.');
    }
    sessions = next;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final next = sessions.where((s) => s.id != id).toList();
    final saved = await preferences.setString('freqfit.sessions.v2',
        jsonEncode(next.map((s) => s.toJson()).toList()));
    if (!saved) throw StateError('Could not delete this session.');
    sessions = next;
    notifyListeners();
  }
}

String dateLabel(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
