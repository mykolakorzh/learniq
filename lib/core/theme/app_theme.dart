import 'package:flutter/material.dart';

class AppTheme {
  // Brand Color Palette - Based on Learniq Logo German Flag Gradient
  // German flag colors: Black-Red-Gold reimagined as gradient
  static const Color brandRed = Color(0xFFDC143C); // Crimson red from flag
  static const Color brandOrange = Color(0xFFFF6B35); // Gradient middle
  static const Color brandGold = Color(0xFFFFD700); // Gold from flag
  static const Color brandDark = Color(0xFF1A1A1A); // Deep black

  // Primary palette derived from brand
  static const Color primaryIndigo = Color(0xFFDC143C); // Brand red as primary
  static const Color secondaryPurple = Color(0xFFFF6B35); // Brand orange
  static const Color accentGreen = Color(0xFF10B981); // Keep for success
  static const Color backgroundLight = Color(0xFFFFFBF5); // Warm off-white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);

  // Article Colors - Enhanced with better contrast
  static const Color derColor = Color(0xFF2563EB); // Vivid blue (masculine)
  static const Color dieColor = Color(0xFFE91E63); // More red, less pink (feminine)
  static const Color dasColor = Color(0xFF10B981); // Vivid green (neutral)

  // Semantic Colors
  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFDC143C); // Use brand red
  static const Color warningColor = Color(0xFFFFB800);
  static const Color infoColor = Color(0xFF2196F3);

  // Brand Gradient - German Flag (Schwarz-Rot-Gold)
  // Primary brand gradient matching logo
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8B0000), // Dark red/burgundy top
      Color(0xFFDC143C), // Crimson red
      Color(0xFFFF6B35), // Orange
      Color(0xFFFFD700), // Gold bottom
    ],
  );

  // Alternative horizontal brand gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC143C), Color(0xFFFF6B35), Color(0xFFFFD700)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  // Red to Gold gradient (warm version)
  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFDC143C), Color(0xFFFFD700)],
  );

  static const LinearGradient derGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
  );

  static const LinearGradient dieGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
  );

  static const LinearGradient dasGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static ThemeData get lightTheme {
    return ThemeData(
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
}