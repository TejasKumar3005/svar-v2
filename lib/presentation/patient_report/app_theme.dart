import 'package:flutter/material.dart';

class AppTheme {
  // Primary colors
  static const Color primaryColor = Color(0xFF26A69A); // More solid teal
  static const Color primaryLightColor = Color(0xFF4DB6AC);
  static const Color primaryDarkColor = Color(0xFF00897B);
  
  // Section header colors
  static const Color basicInfoColor = Color(0xFF26A69A); // Teal
  static const Color concernsColor = Color(0xFFE67E4D);  // Orange
  static const Color medicalHistoryColor = Color(0xFF26A69A); // Teal
  static const Color developmentColor = Color(0xFF26A69A); // Teal
  static const Color recommendationsColor = Color(0xFF26A69A); // Teal
  
  // Background colors
  static const Color scaffoldBackgroundColor = Color(0xFFF9F2EF); // Beige
  static const Color cardColor = Colors.white;
  static const Color cardBgColor = Color(0xFFFAF9FF); // Very light lavender
  
  // Text colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color labelColor = Color(0xFF00897B); // Teal for labels

  // Status colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color errorColor = Color(0xFFE53935);
  static const Color infoColor = Color(0xFF2196F3);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      primaryColorLight: primaryLightColor,
      primaryColorDark: primaryDarkColor,
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: basicInfoColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        primaryContainer: primaryLightColor.withOpacity(0.1),
        onPrimaryContainer: primaryDarkColor,
        error: errorColor,
        background: scaffoldBackgroundColor,
        surface: cardColor,
        onSurface: textPrimaryColor,
        // Additional colors for more nuanced UI
        tertiary: concernsColor,
        tertiaryContainer: Color(0xFFE0F7FA),
        surfaceVariant: cardBgColor,
      ),
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      cardTheme: CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: cardBgColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 24,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        disabledColor: Colors.grey.shade200,
        selectedColor: primaryColor,
        secondarySelectedColor: primaryLightColor,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        labelStyle: TextStyle(color: Colors.grey.shade800),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimaryColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textPrimaryColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textPrimaryColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: textSecondaryColor,
        ),
      ),
    );
  }


    // Define report types with their colors
  static Map<String, Color> reportTypes = {
    'articulation': Colors.green.shade700,
    'Articulation': Colors.green.shade700,
    'language': Colors.purple.shade700,
    'Language': Colors.purple.shade700,
    'fluency': Colors.red.shade700,
    'Fluency': Colors.red.shade700,
    'opm': AppTheme.primaryDarkColor,
    'OPM': AppTheme.primaryDarkColor,
    'opm-functions': AppTheme.primaryDarkColor,
    'prosody': Colors.orange.shade700,
    'Prosody': Colors.orange.shade700,
    'voice': Colors.blueGrey.shade700,
    'Voice': Colors.blueGrey.shade700,
    'case_history': Colors.blue.shade700,
    'Case_history': Colors.blue.shade700,
    'Case History': Colors.blue.shade700,
    'capev': Colors.blueGrey.shade700,
    'isaa': Colors.grey.shade600,
    "adhd": Colors.blue.shade700,
    "mchat": Colors.pinkAccent.shade700,
    "hi":Colors.teal.shade700,
    "cars": Colors.purple.shade700,
    
  };

  static Map<String,Color> borderColors={
    'articulation': Colors.green,
    'Articulation': Colors.green,
    'language': Colors.purple,
    'Language': Colors.purple,
    'fluency': Colors.red,
    'Fluency': Colors.red,
    'opm': AppTheme.primaryDarkColor,
    'OPM': AppTheme.primaryDarkColor,
    'opm-functions': AppTheme.primaryDarkColor,
    'prosody': Colors.orange,
    'Prosody': Colors.orange,
    'voice': Colors.blueGrey,
    'Voice': Colors.blueGrey,
    'case_history': Colors.blue,
    'Case_history': Colors.blue,
    'Case History': Colors.blue,
    'capev': Colors.blueGrey,
    'isaa': Colors.grey.shade600,
    "adhd": Colors.blue,
    "mchat": Colors.pinkAccent,
    "hi": Colors.teal,
    "cars":Colors.purple,
  };
  }