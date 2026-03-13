import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStore {
  static const String _checkInKey = 'checkin_records';
  static const String _finishKey = 'finish_records';
  static const String _lastStudentIdKey = 'last_student_id';

  static Future<void> saveCheckIn(Map<String, dynamic> record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getStringList(_checkInKey) ?? <String>[];
    records.add(jsonEncode(record));
    await prefs.setStringList(_checkInKey, records);
  }

  static Future<void> saveFinish(Map<String, dynamic> record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getStringList(_finishKey) ?? <String>[];
    records.add(jsonEncode(record));
    await prefs.setStringList(_finishKey, records);
  }

  static Future<void> saveLastStudentId(String studentId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastStudentIdKey, studentId);
  }

  static Future<String?> getLastStudentId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastStudentIdKey);
  }
}
