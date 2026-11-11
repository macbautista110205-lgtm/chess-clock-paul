import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves all settings as one JSON string on the device.
class StorageService {
  static const _key = 'chess_clock_settings';

  Future<Map<String, dynamic>?> read() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null; // corrupted data, fall back to defaults
    }
  }

  Future<void> write(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(data));
  }
}
