import 'package:flutter/material.dart';
import '../controllers/settings_controller.dart';
import '../models/time_control.dart';
import '../widgets/settings_section.dart';
import '../widgets/theme_picker.dart';
import '../widgets/time_control_tile.dart';
import 'time_control_form.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.settings});

  final SettingsController settings;

  /// Opens the form. No [existing] means create, otherwise update.
  Future<void> _openForm(BuildContext context, [TimeControl? existing]) async {
    final result = await Navigator.of(context).push<TimeControl>(
      MaterialPageRoute(builder: (_) => TimeControlForm(existing: existing)),
    );
    if (result == null) return;
    if (existing == null) {
      settings.addControl(result);
    } else {
      settings.updateControl(result);
    }
  }

  Future<void> _confirmDelete(BuildContext context, TimeControl c) async {
    if (settings.controls.length <= 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Keep at least one time control.')),
      );
      return;
    }
    final scheme = Theme.of(context).colorScheme;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: scheme.surfaceContainerHighest,
        title: const Text('Delete time control?'),
        content: Text('${c.name} (${c.summary}) will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: scheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) settings.deleteControl(c.id);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.only(bottom: 40),
          children: [
            SettingsSection(
              title: 'Time controls',
              children: [
                for (final c in settings.controls)
                  TimeControlTile(
                    control: c,
                    selected: c.id == settings.selectedId,
                    onSelect: () => settings.select(c.id),
                    onEdit: () => _openForm(context, c),
                    onDelete: () => _confirmDelete(context, c),
                  ),
                ListTile(
                  onTap: () => _openForm(context),
                  leading: Icon(Icons.add_rounded, color: scheme.primary),
                  title: Text(
                    'New time control',
                    style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            SettingsSection(
              title: 'Starting the game',
              children: [
                SwitchListTile(
                  title: const Text('First tap starts my own clock'),
                  subtitle: Text(
                    settings.startOwnClock
                        ? "Tap your side when you're ready"
                        : "Classic: first tap starts the opponent's clock",
                  ),
                  value: settings.startOwnClock,
                  onChanged: settings.setStartOwnClock,
                ),
              ],
            ),
            SettingsSection(
              title: 'Color theme',
              children: [
                ThemePicker(selected: settings.themeIndex, onSelect: settings.setTheme),
              ],
            ),
            SettingsSection(
              title: 'Feedback',
              children: [
                SwitchListTile(
                  title: const Text('Sound'),
                  subtitle: const Text('Tap, low time warning, and time out'),
                  value: settings.sound,
                  onChanged: settings.setSound,
                ),
                SwitchListTile(
                  title: const Text('Vibration'),
                  value: settings.haptics,
                  onChanged: settings.setHaptics,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
