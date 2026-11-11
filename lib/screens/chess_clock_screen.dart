import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/clock_controller.dart';
import '../controllers/settings_controller.dart';
import '../services/sound_service.dart';
import '../widgets/adjust_time_dialog.dart';
import '../widgets/control_bar.dart';
import '../widgets/player_timer.dart';
import 'settings_screen.dart';

class ChessClockScreen extends StatefulWidget {
  const ChessClockScreen({super.key, required this.settings, required this.sound});

  final SettingsController settings;
  final SoundService sound;

  @override
  State<ChessClockScreen> createState() => _ChessClockScreenState();
}

class _ChessClockScreenState extends State<ChessClockScreen> {
  SettingsController get _settings => widget.settings;

  late final ClockController _clock = ClockController(_settings.selected)
    ..onLowTime = ((_) => widget.sound.warn())
    ..onFlag = ((_) {
      widget.sound.flag();
      _vibrate(HapticFeedback.heavyImpact);
    });

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  void _vibrate(Future<void> Function() feedback) {
    if (_settings.haptics) feedback();
  }

  void _onTap(Player p) {
    _clock.startOwnClock = _settings.startOwnClock;
    if (!_clock.tap(p)) return;
    widget.sound.tap();
    _vibrate(HapticFeedback.lightImpact);
  }

  Future<void> _adjust(Player p) async {
    _clock.pause();
    final result = await showDialog<Duration>(
      context: context,
      builder: (_) => RotatedBox(
        quarterTurns: p == Player.top ? 2 : 0,
        child: AdjustTimeDialog(
          title: p == Player.top ? 'Adjust top player' : 'Adjust bottom player',
          initial: _clock.remaining[p]!,
        ),
      ),
    );
    if (result != null) _clock.setTime(p, result);
  }

  Future<void> _openSettings() async {
    _clock.pause();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SettingsScreen(settings: _settings)),
    );
    // Picked or edited a time control? Start fresh with it.
    if (!identical(_settings.selected, _clock.control)) {
      _clock.reset(_settings.selected);
    }
  }

  String _status(Player p) {
    if (_clock.flagged == p) return 'Out of time';
    if (_clock.active == null) {
      return _settings.startOwnClock ? "Tap your side when you're ready" : 'Tap to start';
    }
    if (_clock.paused && _clock.active == p) return 'Paused';
    final m = _clock.moves[p]!;
    return '$m ${m == 1 ? 'move' : 'moves'}';
  }

  Widget _timer(Player p) => Expanded(
        child: PlayerTimer(
          theme: _settings.theme,
          time: _clock.remaining[p]!,
          total: _clock.control.base,
          status: _status(p),
          isActive: _clock.active == p && !_clock.paused,
          isFlagged: _clock.flagged == p,
          isLow: _clock.remaining[p]! <= ClockController.lowTime,
          flipped: p == Player.top,
          onTap: () => _onTap(p),
          onAdjust: () => _adjust(p),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([_clock, _settings]),
      builder: (context, _) => AnnotatedRegion<SystemUiOverlayStyle>(
        // Dark status bar icons on bright themes, light icons on dark ones.
        value: _settings.theme.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: _settings.theme.board,
          body: SafeArea(
            child: Column(
              children: [
                _timer(Player.top),
                ControlBar(
                  theme: _settings.theme,
                  name: _clock.control.name,
                  summary: _clock.control.summary,
                  paused: _clock.paused,
                  canPause: _clock.canPause,
                  onPause: _clock.togglePause,
                  onReset: () => _clock.reset(_settings.selected),
                  onSettings: _openSettings,
                ),
                _timer(Player.bottom),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
