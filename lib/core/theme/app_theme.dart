import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';

export 'app_colors.dart';
export 'app_radius.dart';
export 'app_shadows.dart';
export 'app_spacing.dart';

class AppTheme {
  static const primaryBlue = AppColors.navy;
  static const accentGold = AppColors.gold;
  static const backgroundWhite = AppColors.ivory;
  static const cardWhite = AppColors.surface;
  static const textDark = AppColors.ink;
  static const textLight = AppColors.muted;

  static ThemeData get lightTheme {
    const scheme = ColorScheme.light(
      primary: AppColors.navy,
      onPrimary: Colors.white,
      secondary: AppColors.gold,
      onSecondary: AppColors.navy,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      error: AppColors.error,
      outline: AppColors.divider,
    );
    final textTheme = const TextTheme(
      headlineLarge: TextStyle(
          fontSize: 32,
          height: 1.12,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.8),
      headlineMedium: TextStyle(
          fontSize: 26,
          height: 1.18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4),
      titleLarge:
          TextStyle(fontSize: 20, height: 1.25, fontWeight: FontWeight.w700),
      titleMedium:
          TextStyle(fontSize: 16, height: 1.3, fontWeight: FontWeight.w600),
      titleSmall:
          TextStyle(fontSize: 14, height: 1.3, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16, height: 1.55),
      bodyMedium: TextStyle(fontSize: 14, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, height: 1.4, color: AppColors.muted),
      labelLarge:
          TextStyle(fontSize: 14, height: 1.2, fontWeight: FontWeight.w600),
      labelMedium:
          TextStyle(fontSize: 12, height: 1.2, fontWeight: FontWeight.w600),
    ).apply(bodyColor: AppColors.ink, displayColor: AppColors.ink);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.ivory,
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ivory,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.divider),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.muted),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide: const BorderSide(color: AppColors.divider)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide: const BorderSide(color: AppColors.divider)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide:
                const BorderSide(color: AppColors.secondaryBlue, width: 1.5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium)),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(minimumSize: const Size(48, 48))),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.navy,
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.pill)),
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      ),
      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.secondaryBlue),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      }),
    );
  }
}
