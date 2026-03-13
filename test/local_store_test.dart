import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_class_checkin/data/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('saveCheckIn stores a check-in record', () async {
    final record = <String, dynamic>{
      'studentId': '6500001',
      'timestamp': DateTime(2026, 3, 13, 9, 0).toIso8601String(),
      'latitude': 13.7563,
      'longitude': 100.5018,
      'qrCodeData': 'TEST-QR-001',
      'previousTopic': 'Widget tree',
      'expectedTopic': 'State management',
      'mood': 4,
    };

    await LocalStore.saveCheckIn(record);

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('checkin_records');

    expect(stored, isNotNull);
    expect(stored!.length, 1);
    expect(jsonDecode(stored.first)['studentId'], '6500001');
    expect(jsonDecode(stored.first)['qrCodeData'], 'TEST-QR-001');
  });

  test('saveFinish stores a finish-class record', () async {
    final record = <String, dynamic>{
      'studentId': '6500001',
      'timestamp': DateTime(2026, 3, 13, 12, 0).toIso8601String(),
      'latitude': 13.7563,
      'longitude': 100.5018,
      'qrCodeData': 'TEST-QR-002',
      'learnedToday': 'Learned QR and GPS integration',
      'feedback': 'Great session',
    };

    await LocalStore.saveFinish(record);

    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('finish_records');

    expect(stored, isNotNull);
    expect(stored!.length, 1);
    expect(jsonDecode(stored.first)['studentId'], '6500001');
    expect(jsonDecode(stored.first)['qrCodeData'], 'TEST-QR-002');
  });

  test('saveLastStudentId and getLastStudentId work correctly', () async {
    await LocalStore.saveLastStudentId('6501234');

    final value = await LocalStore.getLastStudentId();
    expect(value, '6501234');
  });
}
