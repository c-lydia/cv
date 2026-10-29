import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get dark => _build(Brightness.dark);
  static ThemeData get light => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xff7dcfff),
          brightness: brightness,
        ).copyWith(
          primary: dark ? const Color(0xff7dcfff) : const Color(0xff265c82),
          secondary: dark ? const Color(0xffbb9af7) : const Color(0xff70549b),
          surface: dark ? const Color(0xff1a1b29) : const Color(0xfff6f7fc),
          onSurface: dark ? const Color(0xffc0caf5) : const Color(0xff202838),
          onSurfaceVariant: dark
              ? const Color(0xffa4aecf)
              : const Color(0xff4e586d),
          outline: dark ? const Color(0xff48566f) : const Color(0xffb8c1d1),
        );
    return ThemeData(
      colorScheme: scheme,
      brightness: brightness,
      fontFamily: 'Ubuntu Sans',
      scaffoldBackgroundColor: dark ? const Color(0xff14151f) : Colors.white,
      dividerColor: scheme.outline.withValues(alpha: .4),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: 16,
          height: 1.65,
          color: scheme.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          height: 1.65,
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
