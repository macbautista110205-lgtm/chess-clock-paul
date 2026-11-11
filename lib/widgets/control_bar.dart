import 'package:flutter/material.dart';
import '../theme/clock_theme.dart';
import 'round_icon_button.dart';

/// Middle strip: current time control on the left, actions on the right.
class ControlBar extends StatelessWidget {
  const ControlBar({
    super.key,
    required this.theme,
    required this.name,
    required this.summary,
    required this.paused,
    required this.canPause,
    required this.onPause,
    required this.onReset,
    required this.onSettings,
  });

  final ClockTheme theme;
  final String name;
  final String summary;
  final bool paused;
  final bool canPause;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final text = theme.idleText;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSettings,
              behavior: HitTestBehavior.opaque,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 13, color: text.withAlpha(150)),
                  ),
                  Text(
                    summary,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: text,
                    ),
                  ),
                ],
              ),
            ),
          ),
          RoundIconButton(
            icon: Icons.restart_alt_rounded,
            tooltip: 'Reset clock',
            onPressed: onReset,
            background: theme.surface,
            foreground: text,
          ),
          const SizedBox(width: 10),
          RoundIconButton(
            icon: paused ? Icons.play_arrow_rounded : Icons.pause_rounded,
            tooltip: paused ? 'Resume' : 'Pause',
            onPressed: canPause ? onPause : null,
            background: canPause ? theme.active : theme.surface,
            foreground: canPause ? theme.activeText : text.withAlpha(80),
            size: 52,
          ),
          const SizedBox(width: 10),
          RoundIconButton(
            icon: Icons.settings_outlined,
            tooltip: 'Settings',
            onPressed: onSettings,
            background: theme.surface,
            foreground: text,
          ),
        ],
      ),
    );
  }
}
