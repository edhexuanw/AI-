import 'package:flutter/material.dart';

class AppTheme {
  static const Color deepTeal = Color(0xFF0E3B43);
  static const Color mint = Color(0xFF3CC9A0);
  static const Color sand = Color(0xFFF5EDE1);
  static const Color coral = Color(0xFFFF8A5B);
  static const Color night = Color(0xFF102126);
  static const Color card = Color(0xFFF9F7F1);

  static ThemeData build() {
    final base = ThemeData(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: sand,
      colorScheme: ColorScheme.fromSeed(
        seedColor: mint,
        primary: deepTeal,
        secondary: coral,
        surface: Colors.white,
      ),
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: night,
          letterSpacing: -1.4,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: night,
          letterSpacing: -0.8,
        ),
        titleLarge: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: night,
        ),
        bodyLarge: const TextStyle(fontSize: 16, height: 1.4, color: night),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: night,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: deepTeal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.white,
        selectedColor: mint.withValues(alpha: 0.16),
      ),
    );
  }

  static BoxDecoration get backgroundDecoration => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF8EE), Color(0xFFE5F7F1), Color(0xFFFFEFE8)],
    ),
  );
}
