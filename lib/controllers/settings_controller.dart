import 'package:flutter/foundation.dart';
import '../models/time_control.dart';
import '../services/storage_service.dart';
import '../theme/clock_theme.dart';

/// App settings plus CRUD for time controls. Every change is saved.
class SettingsController extends ChangeNotifier {
  SettingsController(this._storage);

  final StorageService _storage;

  List<TimeControl> controls = List.of(defaultControls);
  String selectedId = defaultControls[2].id;
  int themeIndex = 0;
  bool sound = true;
  bool haptics = true;
  bool startOwnClock = false; // false = classic chess clock rule

  ClockTheme get theme => clockThemes[themeIndex];

  TimeControl get selected => controls.firstWhere(
        (c) => c.id == selectedId,
        orElse: () => controls.first,
      );

  Future<void> load() async {
    final data = await _storage.read();
    if (data == null) return;
    try {
      final list = data['controls'];
      if (list is List && list.isNotEmpty) {
        controls = [
          for (final e in list) TimeControl.fromJson(Map<String, dynamic>.from(e as Map)),
        ];
      }
      selectedId = data['selectedId'] as String? ?? selectedId;
      themeIndex = ((data['theme'] as int?) ?? 0).clamp(0, clockThemes.length - 1);
      sound = data['sound'] as bool? ?? true;
      haptics = data['haptics'] as bool? ?? true;
      startOwnClock = data['startOwnClock'] as bool? ?? false;
    } catch (_) {
      controls = List.of(defaultControls);
    }
  }

  void _save() {
    notifyListeners();
    _storage.write({
      'controls': [for (final c in controls) c.toJson()],
      'selectedId': selectedId,
      'theme': themeIndex,
      'sound': sound,
      'haptics': haptics,
      'startOwnClock': startOwnClock,
    });
  }

  // Create
  void addControl(TimeControl c) {
    controls.add(c);
    selectedId = c.id;
    _save();
  }

  // Update
  void updateControl(TimeControl c) {
    final i = controls.indexWhere((x) => x.id == c.id);
    if (i < 0) return;
    controls[i] = c;
    _save();
  }

  // Delete (always keeps at least one)
  void deleteControl(String id) {
    if (controls.length <= 1) return;
    controls.removeWhere((c) => c.id == id);
    if (selectedId == id) selectedId = controls.first.id;
    _save();
  }

  void select(String id) {
    selectedId = id;
    _save();
  }

  void setTheme(int i) {
    themeIndex = i;
    _save();
  }

  void setSound(bool v) {
    sound = v;
    _save();
  }

  void setStartOwnClock(bool v) {
    startOwnClock = v;
    _save();
  }

  void setHaptics(bool v) {
    haptics = v;
    _save();
  }
}
