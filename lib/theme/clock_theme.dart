import 'package:flutter/material.dart';

/// Color set for the clock. Idle = waiting side, active = side whose turn it is.
class ClockTheme {
  const ClockTheme(
    this.name, {
    required this.board,
    required this.idle,
    required this.active,
    required this.idleText,
    required this.activeText,
    this.brightness = Brightness.dark,
    this.flag = const Color(0xFFC2413A),
    Color? warn,
  }) : _warn = warn;

  final String name;
  final Brightness brightness;
  final Color board;
  final Color idle;
  final Color active;
  final Color idleText;
  final Color activeText;
  final Color flag;
  final Color? _warn;

  /// Digit color under 10 seconds. Defaults to the flag red.
  Color get warn => _warn ?? flag;

  /// Raised surface for cards, dialogs, and buttons on the board.
  Color get surface => Color.lerp(board, idle, 0.55)!;
}

const _yellow = Color(0xFFFFE066);

const clockThemes = [
  // Calm, dark
  ClockTheme('Walnut',
      board: Color(0xFF1C1410),
      idle: Color(0xFF3A2A20),
      active: Color(0xFFEAD5B3),
      idleText: Color(0xFFDCC6A3),
      activeText: Color(0xFF1C1410)),
  ClockTheme('Tournament',
      board: Color(0xFF121A15),
      idle: Color(0xFF2B3B30),
      active: Color(0xFFE6EBD3),
      idleText: Color(0xFFC6D4C1),
      activeText: Color(0xFF121A15)),
  ClockTheme('Graphite',
      board: Color(0xFF131315),
      idle: Color(0xFF29292D),
      active: Color(0xFFF1EFEA),
      idleText: Color(0xFFD6D4CE),
      activeText: Color(0xFF131315)),
  ClockTheme('Midnight',
      board: Color(0xFF0A1220),
      idle: Color(0xFF1A2A40),
      active: Color(0xFF9EC5EA),
      idleText: Color(0xFFC3D5E9),
      activeText: Color(0xFF0A1220)),
  ClockTheme('Clay',
      board: Color(0xFF1B1214),
      idle: Color(0xFF3A2428),
      active: Color(0xFFEFB383),
      idleText: Color(0xFFE6CBB9),
      activeText: Color(0xFF1B1214)),
  // Colorful, dark
  ClockTheme('Neon',
      board: Color(0xFF0B0F14),
      idle: Color(0xFF1C2530),
      active: Color(0xFF22D3EE),
      idleText: Color(0xFFA5F3FC),
      activeText: Color(0xFF0B0F14)),
  ClockTheme('Grape',
      board: Color(0xFF1E1033),
      idle: Color(0xFF3B2266),
      active: Color(0xFFC084FC),
      idleText: Color(0xFFE9D5FF),
      activeText: Color(0xFF1E1033)),
  // Bright
  ClockTheme('Sky',
      brightness: Brightness.light,
      board: Color(0xFFEEF4FB),
      idle: Color(0xFFD3E2F4),
      active: Color(0xFF2563EB),
      idleText: Color(0xFF1E3A5F),
      activeText: Color(0xFFFFFFFF),
      warn: _yellow),
  ClockTheme('Mint',
      brightness: Brightness.light,
      board: Color(0xFFEEF7F1),
      idle: Color(0xFFCDE8D7),
      active: Color(0xFF16A34A),
      idleText: Color(0xFF14532D),
      activeText: Color(0xFFFFFFFF),
      warn: _yellow),
  ClockTheme('Citrus',
      brightness: Brightness.light,
      board: Color(0xFFFFF8E7),
      idle: Color(0xFFFCE6B0),
      active: Color(0xFFF97316),
      idleText: Color(0xFF7C2D12),
      activeText: Color(0xFFFFFFFF),
      warn: Color(0xFF5A0F0F)),
  ClockTheme('Bubblegum',
      brightness: Brightness.light,
      board: Color(0xFFFDF0F6),
      idle: Color(0xFFF9D2E4),
      active: Color(0xFFEC4899),
      idleText: Color(0xFF831843),
      activeText: Color(0xFFFFFFFF),
      warn: _yellow),
];
