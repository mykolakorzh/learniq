import 'package:flutter/material.dart';

class AppTheme {
  // Modern Color Palette
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color secondaryPurple = Color(0xFF8B5CF6);
  static const Color accentGreen = Color(0xFF10B981);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  
  // Article Colors (softer modern shades)
  static const Color derColor = Color(0xFF3B82F6); // Soft blue
  static const Color dieColor = Color(0xFFEC4899); // Soft pink
  static const Color dasColor = Color(0xFF10B981); // Soft green
  
  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryIndigo, secondaryPurple],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentGreen, Color(0xFF059669)],
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryIndigo,
      brightness: Brightness.light,
      primary: primaryIndigo,
      secondary: secondaryPurple,
      surface: surfaceLight,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimary,
    ),
    scaffoldBackgroundColor: backgroundLight,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      titleTextStyle: TextStyle(
        color: textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 8,
      shadowColor: primaryIndigo.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(8),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryIndigo,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 8,
        shadowColor: primaryIndigo.withValues(alpha: 0.3),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryIndigo,
        side: const BorderSide(color: primaryIndigo, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryIndigo,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryIndigo;
        }
        return Colors.grey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryIndigo.withValues(alpha: 0.3);
        }
        return Colors.grey.withValues(alpha: 0.3);
      }),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryIndigo,
      linearTrackColor: Color(0xFFE2E8F0),
      circularTrackColor: Color(0xFFE2E8F0),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryIndigo, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryIndigo,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),
    ),
  );
} 