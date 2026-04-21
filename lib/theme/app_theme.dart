import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF08090D);
  static const Color surface = Color(0xFF11131A);
  static const Color surfaceSoft = Color(0xFF171B25);
  static const Color stroke = Color(0xFF252B38);
  static const Color textPrimary = Color(0xFFF5F4EE);
  static const Color textMuted = Color(0xFFA3AABD);
  static const Color acid = Color(0xFFD5FF3F);
  static const Color pink = Color(0xFFFF4DB8);
  static const Color cyan = Color(0xFF35E7FF);
  static const Color gold = Color(0xFFFFE66D);
  static const Color violet = Color(0xFF8F73FF);
  static const Color orange = Color(0xFFFF8A5B);
  static const Color mint = Color(0xFF00FFB2);
  static const Color red = Color(0xFFFF3F5E);

  static ThemeData darkTheme() {
    const colorScheme = ColorScheme.dark(
      primary: acid,
      secondary: cyan,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w900,
          height: 0.92,
          color: textPrimary,
          letterSpacing: -2.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          height: 1.0,
          color: textPrimary,
          letterSpacing: -0.8,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: textMuted),
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceSoft,
        hintStyle: const TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: stroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: stroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: acid, width: 1.4),
        ),
        contentPadding: const EdgeInsets.all(20),
      ),
    );
  }
}
