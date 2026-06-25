import 'package:flutter/material.dart';

/// Tema centralizado do app.
///
/// Paleta: azul escuro ([primaryBlue]), dourado ([accentGold]) e fundo claro.
/// Todo o design system (AppBar, cards, botões, chips, texto) é definido aqui.
class AppTheme {
  static const Color primaryBlue = Color(0xFF1A3A6B);
  static const Color accentGold = Color(0xFFD4A853);
  static const Color backgroundWhite = Color(0xFFF8F9FA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1C1C1E);
  static const Color textLight = Color(0xFF6B7280);

  /// Tema claro completo do Material 3.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: accentGold,
        surface: backgroundWhite,
      ),
      scaffoldBackgroundColor: backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardWhite,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryBlue.withValues(alpha: 0.1),
        labelStyle: const TextStyle(color: primaryBlue, fontSize: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(
          color: textDark,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: textDark,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textDark,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(color: textDark, fontSize: 14, height: 1.5),
        bodySmall: TextStyle(color: textLight, fontSize: 12),
      ),
    );
  }
}
