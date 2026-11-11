import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Fix a player's time: scroll the picker or nudge with the quick buttons.
class AdjustTimeDialog extends StatefulWidget {
  const AdjustTimeDialog({super.key, required this.title, required this.initial});

  final String title;
  final Duration initial;

  @override
  State<AdjustTimeDialog> createState() => _AdjustTimeDialogState();
}

class _AdjustTimeDialogState extends State<AdjustTimeDialog> {
  static const _rows = [
    [Duration(minutes: -1), Duration(seconds: -10), Duration(seconds: -1)],
    [Duration(seconds: 1), Duration(seconds: 10), Duration(minutes: 1)],
  ];

  late Duration _time = Duration(seconds: widget.initial.inSeconds);
  int _pickerKey = 0; // bump to redraw the picker after a quick button

  String _label(Duration d) {
    final sign = d.isNegative ? '-' : '+';
    final a = d.abs();
    return a.inMinutes > 0 ? '$sign${a.inMinutes} min' : '$sign${a.inSeconds} s';
  }

  void _bump(Duration d) {
    final next = _time + d;
    if (next >= const Duration(hours: 24)) return;
    setState(() {
      _time = next.isNegative ? Duration.zero : next;
      _pickerKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: scheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Scroll to set the exact time, or nudge it below.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurface.withAlpha(150)),
            ),
            SizedBox(
              height: 160,
              child: CupertinoTimerPicker(
                key: ValueKey(_pickerKey),
                mode: CupertinoTimerPickerMode.hms,
                initialTimerDuration: _time,
                backgroundColor: Colors.transparent,
                onTimerDurationChanged: (d) => _time = d,
              ),
            ),
            for (final row in _rows)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    for (final s in row)
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilledButton.tonal(
                            onPressed: () => _bump(s),
                            child: Text(_label(s)),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context, _time),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
