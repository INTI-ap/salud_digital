import 'package:flutter/material.dart';

/// Tema institucional de la aplicación con soporte para Material 3,
/// modo claro/oscuro y variantes de alto contraste.
///
/// Cumple con las pautas de accesibilidad para personas mayores:
/// - Contraste superior a 4.5:1 (y 7:1 en alto contraste)
/// - Tipografía escalable con base mínima en 18 sp
/// - Objetivos táctiles mínimos de 48 × 48 dp
class AppTheme {
  const AppTheme._();

  static const Color azulInstitucional = Color(0xFF194D84);
  static const Color cianInstitucional = Color(0xFF00CEFE);
  static const Color fondoClaro = Color(0xFFF7F9FC);
  static const Color fondoOscuro = Color(0xFF121418);

  static ThemeData get claro => _tema(Brightness.light);
  static ThemeData get oscuro => _tema(Brightness.dark);
  static ThemeData get altoContrasteClaro =>
      _tema(Brightness.light, contraste: 1.0);
  static ThemeData get altoContrasteOscuro =>
      _tema(Brightness.dark, contraste: 1.0);

  static ThemeData _tema(Brightness brightness, {double contraste = 0.0}) {
    final esOscuro = brightness == Brightness.dark;
    final esquema = ColorScheme.fromSeed(
      seedColor: azulInstitucional,
      brightness: brightness,
      contrastLevel: contraste,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: esquema,
      scaffoldBackgroundColor: esOscuro ? fondoOscuro : fondoClaro,
      textTheme: TextTheme(
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: esquema.onSurface,
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: esquema.onSurface,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: esquema.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: 18,
          height: 1.35,
          color: esquema.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: 18,
          height: 1.35,
          color: esquema.onSurface,
        ),
        labelLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: esOscuro ? esquema.surfaceContainer : azulInstitucional,
        foregroundColor: esOscuro ? esquema.onSurface : Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: esOscuro ? esquema.onSurface : Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: esOscuro ? esquema.surfaceContainerHighest : Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor:
            esOscuro ? esquema.primaryContainer : azulInstitucional,
        foregroundColor:
            esOscuro ? esquema.onPrimaryContainer : Colors.white,
      ),
    );
  }
}
