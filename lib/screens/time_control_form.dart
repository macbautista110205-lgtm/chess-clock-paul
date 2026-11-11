import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/time_control.dart';
import '../widgets/settings_section.dart';

/// Create or edit a time control. Pops with the saved control.
class TimeControlForm extends StatefulWidget {
  const TimeControlForm({super.key, this.existing});

  final TimeControl? existing;

  @override
  State<TimeControlForm> createState() => _TimeControlFormState();
}

class _TimeControlFormState extends State<TimeControlForm> {
  late final _name = TextEditingController(text: widget.existing?.name ?? '');
  late Duration _base = widget.existing?.base ?? const Duration(minutes: 5);
  late Duration _increment = widget.existing?.increment ?? Duration.zero;

  bool get _isEdit => widget.existing != null;

  TimeControl get _draft => TimeControl(
        id: widget.existing?.id ?? TimeControl.newId(),
        name: _name.text.trim().isEmpty ? 'Custom' : _name.text.trim(),
        base: _base,
        increment: _increment,
      );

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    if (_base == Duration.zero) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set a base time above zero.')),
      );
      return;
    }
    Navigator.pop(context, _draft);
  }

  Widget _picker(CupertinoTimerPickerMode mode, Duration initial, ValueChanged<Duration> onChanged) {
    return SizedBox(
      height: 170,
      child: CupertinoTimerPicker(
        mode: mode,
        initialTimerDuration: initial,
        backgroundColor: Colors.transparent,
        onTimerDurationChanged: (d) => setState(() => onChanged(d)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurface.withAlpha(150);
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit time control' : 'New time control')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Club blitz'),
            ),
          ),
          SettingsSection(
            title: 'Base time',
            children: [_picker(CupertinoTimerPickerMode.hms, _base, (d) => _base = d)],
          ),
          SettingsSection(
            title: 'Increment per move',
            children: [_picker(CupertinoTimerPickerMode.ms, _increment, (d) => _increment = d)],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Text(
              'Each player starts with ${_draft.summary} per move.',
              style: TextStyle(color: muted),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          onPressed: _save,
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          child: Text(
            _isEdit ? 'Save changes' : 'Create time control',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
