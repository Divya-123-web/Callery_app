import 'package:flutter/material.dart';

/// Central place for all colors used in the Calley app.
/// Values are picked from the Figma reference screenshots.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF2563EB); // main blue (buttons, banner)
  static const Color navy = Color(0xFF1E3A6E); // dark blue headers
  static const Color background = Color(0xFFF8FAFC); // screen background
  static const Color card = Colors.white;

  // Text
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGrey = Color(0xFF64748B);

  // Borders & fields
  static const Color border = Color(0xFFD6DCE8);
  static const Color lightBlue = Color(0xFFEEF3FF); // drawer / list tiles

  // Call status colors (dashboard chart and tiles)
  static const Color pending = Color(0xFFFBA93A);
  static const Color pendingBg = Color(0xFFFFF0DD);
  static const Color done = Color(0xFF1FB141);
  static const Color doneBg = Color(0xFFDFFBE0);
  static const Color schedule = Color(0xFF9B6AF2);
  static const Color scheduleBg = Color(0xFFF1EDFC);

  // Feedback
  static const Color error = Color(0xFFDC2626);
  static const Color whatsapp = Color(0xFF25D366);
}

/// App-wide Material theme.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.background,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(54),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: const TextStyle(color: AppColors.textDark, fontSize: 16),
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: inputBorder.copyWith(
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
      ),
    );
  }
}