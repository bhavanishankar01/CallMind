import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryViolet = Color(0xFF6C5CE7);
  static const Color primaryDarkViolet = Color(0xFF4834D4);
  static const Color secondaryIndigo = Color(0xFF3867D6);
  static const Color accentCyan = Color(0xFF00CEC9);
  
  // Status Colors
  static const Color statusScheduled = Color(0xFF0984E3); // Blue
  static const Color statusCalling = Color(0xFFFD9644);   // Orange pulse
  static const Color statusCompleted = Color(0xFF26DE81); // Emerald Green
  static const Color statusMissed = Color(0xFFEB3B5A);    // Coral Red
  static const Color statusFailed = Color(0xFFFC5C65);    // Soft Red
  static const Color statusCancelled = Color(0xFF778CA3); // Muted Slate Gray

  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8F9FE);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnSurface = Color(0xFF1E272E);
  static const Color lightSubtext = Color(0xFF636E72);

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkOnSurface = Color(0xFFF8FAFC);
  static const Color darkSubtext = Color(0xFF94A3B8);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryViolet,
      onPrimary: Colors.white,
      secondary: secondaryIndigo,
      surface: lightSurface,
      onSurface: lightOnSurface,
      error: statusMissed,
    ),
    scaffoldBackgroundColor: lightBackground,
    textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: lightOnSurface),
      headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: lightOnSurface),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: lightOnSurface),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: lightOnSurface),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: lightSubtext),
    ),
    cardTheme: CardTheme(
      color: lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: lightBackground,
      elevation: 0,
      scaffoldBackgroundColor: lightBackground,
      iconTheme: const IconThemeData(color: lightOnSurface),
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: lightOnSurface,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryViolet, width: 2),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryViolet,
      onPrimary: Colors.white,
      secondary: accentCyan,
      surface: darkSurface,
      onSurface: darkOnSurface,
      error: statusMissed,
    ),
    scaffoldBackgroundColor: darkBackground,
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: darkOnSurface),
      headlineMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: darkOnSurface),
      titleLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: darkOnSurface),
      bodyLarge: GoogleFonts.inter(fontSize: 16, color: darkOnSurface),
      bodyMedium: GoogleFonts.inter(fontSize: 14, color: darkSubtext),
    ),
    cardTheme: CardTheme(
      color: darkSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFF334155), width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      scaffoldBackgroundColor: darkBackground,
      iconTheme: const IconThemeData(color: darkOnSurface),
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: darkOnSurface,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryViolet,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF334155)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primaryViolet, width: 2),
      ),
    ),
  );
}
