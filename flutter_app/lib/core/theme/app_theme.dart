import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Reds
  static const Color brand50 = Color(0xFFFEF2F2);
  static const Color brand100 = Color(0xFFFEE2E2);
  static const Color brand500 = Color(0xFFEF4444);
  static const Color brand600 = Color(0xFFDC2626);
  static const Color brand700 = Color(0xFFB91C1C);
  static const Color brand800 = Color(0xFF991B1B);
  static const Color brand900 = Color(0xFF7F1D1D);
  static const Color brand950 = Color(0xFF450A0A);

  // Surfaces & Neutrals
  static const Color surface50 = Color(0xFFFAFAFA);
  static const Color surface100 = Color(0xFFF4F4F5);
  static const Color surface200 = Color(0xFFE4E4E7);
  static const Color surface300 = Color(0xFFD4D4D8);
  static const Color surface400 = Color(0xFFA1A1AA);
  static const Color surface500 = Color(0xFF71717A);
  static const Color surface600 = Color(0xFF52525B);
  static const Color surface700 = Color(0xFF3F3F46);
  static const Color surface800 = Color(0xFF27272A);
  static const Color surface900 = Color(0xFF18181B);
  static const Color surface950 = Color(0xFF09090B);

  // Status & Highlights
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color blue500 = Color(0xFF3B82F6);
}

class AppTheme {
  static ThemeData get lightTheme {
    final baseText = GoogleFonts.plusJakartaSansTextTheme();
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.brand700,
      scaffoldBackgroundColor: AppColors.surface50,
      colorScheme: const ColorScheme.light(
        primary: AppColors.brand700,
        secondary: AppColors.amber500,
        surface: Colors.white,
        onSurface: AppColors.surface900,
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.surface900),
        displayMedium: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.surface900),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.surface900),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.surface900),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.surface800),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.surface600),
        labelSmall: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.surface500),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.brand700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseText = GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme);
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.brand700,
      scaffoldBackgroundColor: AppColors.surface950,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.brand700,
        secondary: AppColors.amber400,
        surface: AppColors.surface900,
        onSurface: Colors.white,
      ),
      textTheme: baseText.copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
        displayMedium: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
        titleLarge: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        titleMedium: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.surface200),
        bodyMedium: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.surface400),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface900,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.surface800),
        ),
      ),
    );
  }
}
