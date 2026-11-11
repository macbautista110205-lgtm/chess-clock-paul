import 'package:flutter/material.dart';
import '../theme/clock_theme.dart';

/// Grid of mini clock previews, one per color theme. Wraps to new rows.
class ThemePicker extends StatelessWidget {
  const ThemePicker({super.key, required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      child: Wrap(
        spacing: 6,
        runSpacing: 14,
        children: [
          for (var i = 0; i < clockThemes.length; i++)
            _swatch(clockThemes[i], i == selected, scheme, () => onSelect(i)),
        ],
      ),
    );
  }

  Widget _swatch(ClockTheme t, bool isOn, ColorScheme scheme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 56,
              height: 72,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: t.board,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isOn ? scheme.primary : scheme.onSurface.withAlpha(30),
                  width: isOn ? 2.5 : 1,
                ),
              ),
              child: Column(
                children: [
                  Expanded(child: _panel(t.idle)),
                  const SizedBox(height: 3),
                  Expanded(child: _panel(t.active)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isOn ? FontWeight.w600 : FontWeight.w400,
                color: scheme.onSurface.withAlpha(isOn ? 255 : 160),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panel(Color c) => DecoratedBox(
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(8)),
        child: const SizedBox.expand(),
      );
}
