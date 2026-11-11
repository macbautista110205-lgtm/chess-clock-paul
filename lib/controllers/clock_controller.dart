import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/time_control.dart';

enum Player { top, bottom }

/// Holds all clock logic. The UI only listens and calls methods.
class ClockController extends ChangeNotifier {
  ClockController(this.control) {
    reset();
  }

  static const lowTime = Duration(seconds: 10);

  TimeControl control;
  final Map<Player, Duration> remaining = {};
  final Map<Player, int> moves = {};
  Player? active;
  Player? flagged;
  bool paused = false;

  /// Classic (false): first tap starts the opponent. True: first tap starts your own.
  bool startOwnClock = false;

  ValueChanged<Player>? onLowTime;
  ValueChanged<Player>? onFlag;

  Timer? _ticker;
  DateTime? _lastTick;

  bool get canPause => active != null && flagged == null;

  Player _other(Player p) => p == Player.top ? Player.bottom : Player.top;

  /// A player taps their own side to end their turn. Returns true if it counted.
  bool tap(Player p) {
    if (flagged != null || paused) return false;
    if (active == null) {
      active = startOwnClock ? p : _other(p);
      _startTicker();
    } else if (active == p) {
      remaining[p] = remaining[p]! + control.increment;
      moves[p] = moves[p]! + 1;
      active = _other(p);
    } else {
      return false;
    }
    notifyListeners();
    return true;
  }

  void togglePause() {
    if (!canPause) return;
    paused = !paused;
    if (paused) {
      _stop();
    } else {
      _startTicker();
    }
    notifyListeners();
  }

  void pause() {
    if (canPause && !paused) togglePause();
  }

  /// Manually set a player's time. Also revives a flagged player (paused).
  void setTime(Player p, Duration d) {
    remaining[p] = d;
    if (flagged == p && d > Duration.zero) {
      flagged = null;
      paused = true;
    }
    notifyListeners();
  }

  void reset([TimeControl? next]) {
    _stop();
    if (next != null) control = next;
    for (final p in Player.values) {
      remaining[p] = control.base;
      moves[p] = 0;
    }
    active = null;
    flagged = null;
    paused = false;
    notifyListeners();
  }

  void _startTicker() {
    _lastTick = DateTime.now();
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 100), (_) => _tick());
  }

  /// Uses real elapsed time so the clock stays accurate even if frames lag.
  void _tick() {
    final now = DateTime.now();
    final elapsed = now.difference(_lastTick!);
    _lastTick = now;
    final p = active;
    if (p == null) return;
    final before = remaining[p]!;
    final left = before - elapsed;
    if (left <= Duration.zero) {
      remaining[p] = Duration.zero;
      flagged = p;
      _stop();
      onFlag?.call(p);
    } else {
      remaining[p] = left;
      if (before > lowTime && left <= lowTime) onLowTime?.call(p);
    }
    notifyListeners();
  }

  void _stop() => _ticker?.cancel();

  @override
  void dispose() {
    _stop();
    super.dispose();
  }
}
