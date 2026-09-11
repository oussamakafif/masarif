import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF14532D);
  static const Color deepGreen = Color(0xFF0B3D26);
  static const Color gold = Color(0xFFC9A227);
  static const Color background = Color(0xFFF6F4EF);
  static const Color cardBackground = Colors.white;
  static const Color textDark = Color(0xFF1B1E1C);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color success = Color(0xFF2E7D32);
  static const Color danger = Color(0xFFB3261E);
  static const Color chipBackground = Color(0xFFEFEDE6);
  static const Color saudiAccent = Color(0xFFDDA53B);
  static const Color algeriaAccent = Color(0xFF1F7A4D);

  // category colors used in charts/legends
  static const Color catGroceries = Color(0xFF1E824C);
  static const Color catBills = Color(0xFFDDA53B);
  static const Color catFood = Color(0xFFE08E45);
  static const Color catHealth = Color(0xFF2F8F9D);
  static const Color catTransport = Color(0xFF8C8C8C);
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
    );
    final textTheme = GoogleFonts.tajawalTextTheme(base.textTheme).apply(
      bodyColor: AppColors.textDark,
      displayColor: AppColors.textDark,
    );
    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
