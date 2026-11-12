import 'package:flutter/material.dart';

/// Tema institucional de la aplicación.
///
/// Mantiene los criterios de accesibilidad de la unidad: texto base de 18 sp,
/// alto contraste y botones con un área táctil mínima de 48 × 48.
class AppTheme {
  const AppTheme._();

  static const Color azulInstitucional = Color(0xFF194D84);
  static const Color cianInstitucional = Color(0xFF00CEFE);
  static const Color fondo = Color(0xFFF7F9FC);

  static ThemeData get claro {
    final esquema = ColorScheme.fromSeed(
      seedColor: azulInstitucional,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: fondo,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 18, height: 1.35),
        bodyMedium: TextStyle(fontSize: 18, height: 1.35),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: azulInstitucional,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: azulInstitucional,
        foregroundColor: Colors.white,
      ),
    );
  }
}
