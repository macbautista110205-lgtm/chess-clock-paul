import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'clock_theme.dart';

const clockFont = 'BarlowSemiCondensed';

/// Builds the Material theme for settings, dialogs, and forms from a ClockTheme.
ThemeData buildAppTheme(ClockTheme t) {
  final scheme = ColorScheme.fromSeed(
    seedColor: t.active,
    brightness: t.brightness,
  ).copyWith(
    primary: t.active,
    onPrimary: t.activeText,
    surface: t.board,
    onSurface: t.idleText,
    surfaceContainerHighest: t.surface,
    error: t.flag,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    fontFamily: 'Barlow',
    scaffoldBackgroundColor: t.board,
    dividerColor: t.idleText.withAlpha(28),
    appBarTheme: AppBarTheme(
      backgroundColor: t.board,
      foregroundColor: t.idleText,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Barlow',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: t.idleText,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: t.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    cupertinoOverrideTheme: CupertinoThemeData(
      brightness: t.brightness,
      primaryColor: t.active,
      textTheme: CupertinoTextThemeData(
        pickerTextStyle: TextStyle(fontSize: 22, color: t.idleText),
      ),
    ),
  );
}
