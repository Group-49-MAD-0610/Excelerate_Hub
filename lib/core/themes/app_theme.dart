import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';

/// Application theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeConstants.primaryColor,
        brightness: Brightness.light,
        primary: ThemeConstants.primaryColor,
        secondary: ThemeConstants.secondaryColor,
        tertiary: ThemeConstants.tertiaryColor,
        surface: ThemeConstants.surfaceColor,
        error: ThemeConstants.errorColor,
        onSurface: ThemeConstants.onSurfaceColor,
        outline: ThemeConstants.outlineColor,
        surfaceContainerHighest: ThemeConstants.surfaceVariantColor,
        onSurfaceVariant: ThemeConstants.onSurfaceVariantColor,
      ),

      // Typography
      textTheme: _buildTextTheme(),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeConstants.surfaceColor,
        foregroundColor: ThemeConstants.onSurfaceColor,
        elevation: ThemeConstants.elevationNone,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.titleLargeFontSize,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.onSurfaceColor,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: ThemeConstants.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeConstants.primaryColor,
          backgroundColor: ThemeConstants.surfaceColor,
          side: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeConstants.secondaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing20,
            vertical: ThemeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: ThemeConstants.courseCardColor,
        elevation: ThemeConstants.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ThemeConstants.borderRadiusLarge),
          ),
          side: BorderSide(color: ThemeConstants.surfaceVariantColor, width: 1),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing8,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ThemeConstants.surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.outlineColor,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.outlineColor,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing16,
        ),
        labelStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: ThemeConstants.onSurfaceVariantColor,
        ),
        hintStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: ThemeConstants.onSurfaceVariantColor,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ThemeConstants.surfaceColor,
        selectedItemColor: ThemeConstants.primaryColor,
        unselectedItemColor: ThemeConstants.onSurfaceVariantColor,
        type: BottomNavigationBarType.fixed,
        elevation: ThemeConstants.elevationMedium,
        selectedLabelStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelSmallFontSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelSmallFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: ThemeConstants.programBadgeColor,
        labelStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelMediumFontSize,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing12,
          vertical: ThemeConstants.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeConstants.progressBarColor,
        linearTrackColor: ThemeConstants.surfaceVariantColor,
        circularTrackColor: ThemeConstants.surfaceVariantColor,
      ),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme for dark mode
      colorScheme: ColorScheme.fromSeed(
        seedColor: ThemeConstants.primaryColor,
        brightness: Brightness.dark,
        primary: ThemeConstants.primaryColor,
        secondary: ThemeConstants.secondaryColor,
        tertiary: ThemeConstants.tertiaryColor,
        surface: const Color(0xFF121212),
        error: const Color(0xFFCF6679),
        onSurface: const Color(0xFFE1E1E1),
        outline: const Color(0xFF938F99),
        surfaceContainerHighest: const Color(0xFF2D2D2D),
        onSurfaceVariant: const Color(0xFFCAC4D0),
      ),

      // Typography
      textTheme: _buildTextTheme(isDark: true),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF121212),
        foregroundColor: Color(0xFFE1E1E1),
        elevation: ThemeConstants.elevationNone,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.titleLargeFontSize,
          fontWeight: FontWeight.w600,
          color: Color(0xFFE1E1E1),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeConstants.primaryColor,
          foregroundColor: Colors.white,
          elevation: ThemeConstants.elevationNone,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ThemeConstants.primaryColor,
          backgroundColor: const Color(0xFF1E1E1E),
          side: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing24,
            vertical: ThemeConstants.spacing16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ThemeConstants.secondaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacing20,
            vertical: ThemeConstants.spacing12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              ThemeConstants.borderRadiusMedium,
            ),
          ),
          textStyle: const TextStyle(
            fontFamily: ThemeConstants.primaryFontFamily,
            fontSize: ThemeConstants.bodyMediumFontSize,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: ThemeConstants.elevationSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(ThemeConstants.borderRadiusLarge),
          ),
          side: BorderSide(color: Color(0xFF2D2D2D), width: 1),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing8,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(color: Color(0xFF938F99), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(color: Color(0xFF938F99), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(
            color: ThemeConstants.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            ThemeConstants.borderRadiusMedium,
          ),
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing16,
          vertical: ThemeConstants.spacing16,
        ),
        labelStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: Color(0xFFCAC4D0),
        ),
        hintStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.bodyMediumFontSize,
          color: Color(0xFFCAC4D0),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF121212),
        selectedItemColor: ThemeConstants.primaryColor,
        unselectedItemColor: Color(0xFFCAC4D0),
        type: BottomNavigationBarType.fixed,
        elevation: ThemeConstants.elevationMedium,
        selectedLabelStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelSmallFontSize,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelSmallFontSize,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2D2D2D),
        labelStyle: const TextStyle(
          fontFamily: ThemeConstants.primaryFontFamily,
          fontSize: ThemeConstants.labelMediumFontSize,
          fontWeight: FontWeight.w600,
          color: ThemeConstants.primaryColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacing12,
          vertical: ThemeConstants.spacing8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.borderRadiusLarge),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeConstants.progressBarColor,
        linearTrackColor: Color(0xFF2D2D2D),
        circularTrackColor: Color(0xFF2D2D2D),
      ),
    );
  }

  /// Build custom text theme
  static TextTheme _buildTextTheme({bool isDark = false}) {
    final onSurfaceColor = isDark
        ? const Color(0xFFE1E1E1)
        : ThemeConstants.onSurfaceColor;
    final onSurfaceVariantColor = isDark
        ? const Color(0xFFCAC4D0)
        : ThemeConstants.onSurfaceVariantColor;

    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.displayLargeFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor,
      ),
      displayMedium: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.displayMediumFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor,
      ),
      displaySmall: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.displaySmallFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor,
      ),
      headlineLarge: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.headlineLargeFontSize,
        fontWeight: FontWeight.w700,
        color: onSurfaceColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.headlineMediumFontSize,
        fontWeight: FontWeight.w600,
        color: onSurfaceColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.headlineSmallFontSize,
        fontWeight: FontWeight.w600,
        color: onSurfaceColor,
      ),
      titleLarge: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.titleLargeFontSize,
        fontWeight: FontWeight.w600,
        color: onSurfaceColor,
      ),
      titleMedium: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.titleMediumFontSize,
        fontWeight: FontWeight.w500,
        color: onSurfaceColor,
      ),
      titleSmall: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.titleSmallFontSize,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariantColor,
      ),
      bodyLarge: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.bodyLargeFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.bodyMediumFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceColor,
      ),
      bodySmall: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.bodySmallFontSize,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariantColor,
      ),
      labelLarge: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.labelLargeFontSize,
        fontWeight: FontWeight.w500,
        color: onSurfaceColor,
      ),
      labelMedium: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.labelMediumFontSize,
        fontWeight: FontWeight.w500,
        color: onSurfaceColor,
      ),
      labelSmall: TextStyle(
        fontFamily: ThemeConstants.primaryFontFamily,
        fontSize: ThemeConstants.labelSmallFontSize,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariantColor,
      ),
    );
  }
}
