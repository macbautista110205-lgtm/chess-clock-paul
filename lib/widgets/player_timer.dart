import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/clock_theme.dart';
import '../utils/format_time.dart';

/// One player's panel. Tap anywhere to end your turn; Adjust fixes the time.
class PlayerTimer extends StatelessWidget {
  const PlayerTimer({
    super.key,
    required this.theme,
    required this.time,
    required this.total,
    required this.status,
    required this.isActive,
    required this.isFlagged,
    required this.isLow,
    required this.onTap,
    required this.onAdjust,
    this.flipped = false,
  });

  final ClockTheme theme;
  final Duration time;
  final Duration total;
  final String status;
  final bool isActive;
  final bool isFlagged;
  final bool isLow;
  final VoidCallback onTap;
  final VoidCallback onAdjust;
  final bool flipped;

  @override
  Widget build(BuildContext context) {
    final bg = isFlagged
        ? theme.flag
        : isActive
            ? theme.active
            : theme.idle;
    final fg = isFlagged
        ? Colors.white
        : isActive
            ? theme.activeText
            : theme.idleText;
    final timeColor = isActive && isLow ? theme.warn : fg;
    final progress = total.inMilliseconds == 0
        ? 0.0
        : (time.inMilliseconds / total.inMilliseconds).clamp(0.0, 1.0);

    return RotatedBox(
      quarterTurns: flipped ? 2 : 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 14, 14),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            formatTime(time),
                            style: TextStyle(
                              fontFamily: clockFont,
                              fontSize: 128,
                              fontWeight: FontWeight.w500,
                              height: 1,
                              letterSpacing: -2,
                              color: timeColor,
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 3,
                          backgroundColor: fg.withAlpha(30),
                          valueColor: AlwaysStoppedAnimation(fg.withAlpha(150)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            status,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: fg.withAlpha(170),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: onAdjust,
                          style: TextButton.styleFrom(
                            foregroundColor: fg,
                            backgroundColor: fg.withAlpha(22),
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            visualDensity: VisualDensity.compact,
                          ),
                          icon: const Icon(Icons.tune_rounded, size: 18),
                          label: const Text(
                            'Adjust',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
