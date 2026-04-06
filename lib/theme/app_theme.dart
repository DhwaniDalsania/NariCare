import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Theme Colors
  static const Color primary = Color(0xFF391D2F);
  static const Color primaryLight = Color(0xFF5C324C);
  static const Color accentCream = Color(0xFFFDFAF7);
  static const Color backgroundLight = Color(0xFFF7F6F7);
  static const Color backgroundDark = Color(0xFF1C161A);

  static const Color accentPink = Color(0xFFFCE7F3);
  static const Color accentPurple = Color(0xFF70415E);
  static const Color accentSoft = Color(0xFFE8DFE4);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: accentPink,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.manropeTextTheme(ThemeData.light().textTheme),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: accentCream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
