import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {

  // =========================
  // LIGHT THEME
  // =========================

  static ThemeData lightTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.light,

    fontFamily: 'PlusJakartaSans',

    scaffoldBackgroundColor:
        AppColors.background,

    primaryColor:
        AppColors.primary,

    colorScheme: ColorScheme.light(

      primary: AppColors.primary,

      secondary: AppColors.secondary,

      surface: Colors.white,
    ),

    textTheme: const TextTheme(

      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
        height: 1.1,
      ),

      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),

      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      ),

      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ),

    appBarTheme: const AppBarTheme(

      elevation: 0,

      centerTitle: false,

      backgroundColor:
          Colors.transparent,

      foregroundColor:
          AppColors.textPrimary,

      titleTextStyle: TextStyle(

        fontFamily:
            'PlusJakartaSans',

        fontSize: 24,

        fontWeight:
            FontWeight.w800,

        color:
            AppColors.textPrimary,
      ),
    ),

    cardTheme: CardThemeData(

      color: AppColors.card,

      elevation: 0,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
    ),

    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(

      selectedItemColor:
          AppColors.primary,

      unselectedItemColor:
          AppColors.textSecondary,

      backgroundColor:
          Colors.white,

      elevation: 0,

      type:
          BottomNavigationBarType.fixed,
    ),

    dividerColor:
        AppColors.border,

    splashColor:
        Colors.transparent,

    highlightColor:
        Colors.transparent,
  );

  // =========================
  // DARK THEME
  // =========================

  static ThemeData darkTheme = ThemeData(

    useMaterial3: true,

    brightness: Brightness.dark,

    fontFamily: 'PlusJakartaSans',

    scaffoldBackgroundColor:
        AppColors.darkBackground,

    primaryColor:
        AppColors.primaryLight,

    colorScheme: ColorScheme.dark(

      primary:
          AppColors.primaryLight,

      secondary:
          AppColors.secondary,

      surface:
          AppColors.darkSurface,
    ),

    textTheme: const TextTheme(

      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color:
            AppColors.darkTextPrimary,
        height: 1.1,
      ),

      headlineMedium: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w800,
        color:
            AppColors.darkTextPrimary,
      ),

      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color:
            AppColors.darkTextPrimary,
      ),

      titleMedium: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color:
            AppColors.darkTextPrimary,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color:
            AppColors.darkTextPrimary,
      ),

      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color:
            AppColors.darkTextSecondary,
      ),

      labelLarge: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
      ),
    ),

    appBarTheme: const AppBarTheme(

      elevation: 0,

      centerTitle: false,

      backgroundColor:
          Colors.transparent,

      foregroundColor:
          AppColors.darkTextPrimary,

      titleTextStyle: TextStyle(

        fontFamily:
            'PlusJakartaSans',

        fontSize: 24,

        fontWeight:
            FontWeight.w800,

        color:
            AppColors.darkTextPrimary,
      ),
    ),

    cardTheme: CardThemeData(

      color: AppColors.darkCard,

      elevation: 0,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(24),
      ),
    ),

    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(

      selectedItemColor:
          AppColors.primaryLight,

      unselectedItemColor:
          AppColors.darkTextSecondary,

      backgroundColor:
          AppColors.darkSurface,

      elevation: 0,

      type:
          BottomNavigationBarType.fixed,
    ),

    dividerColor:
        AppColors.glassBorder,

    splashColor:
        Colors.transparent,

    highlightColor:
        Colors.transparent,
  );
}