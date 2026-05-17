import 'package:flutter/material.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/values.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: MyColors.lightPrimary,
      colorScheme: const ColorScheme.light(
        primary: MyColors.lightPrimary,
        secondary: MyColors.lightSecondary,
        surface: MyColors.lightSurface,
        onPrimary: MyColors.lightOnPrimary,
        onSecondary: MyColors.lightOnSecondary,
        onSurface: MyColors.lightOnSurface,
        error: MyColors.error,
      ),
      scaffoldBackgroundColor: MyColors.lightSurface,
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
        color: MyColors.lightSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.lightPrimary,
        foregroundColor: MyColors.lightOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MyColors.lightOnPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.lightPrimary,
          foregroundColor: MyColors.lightOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: MyColors.lightPrimary,
          side: const BorderSide(color: MyColors.lightPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MyColors.lightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
          borderSide: const BorderSide(color: MyColors.lightPrimary, width: 2),
        ),
        contentPadding: Values.defaultPaddingSmall,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.lightOnSurface),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.lightOnSurface),
        bodyLarge: TextStyle(fontSize: 16, color: MyColors.lightOnSurface),
        bodyMedium: TextStyle(fontSize: 14, color: MyColors.lightOnSurface),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: MyColors.darkPrimary,
      colorScheme: const ColorScheme.dark(
        primary: MyColors.darkPrimary,
        secondary: MyColors.darkSecondary,
        surface: MyColors.darkSurface,
        onPrimary: MyColors.darkOnPrimary,
        onSecondary: MyColors.darkOnSecondary,
        onSurface: MyColors.darkOnSurface,
        error: MyColors.error,
      ),
      scaffoldBackgroundColor: MyColors.darkSurface,
      cardTheme: CardThemeData(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
        color: MyColors.darkSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.darkSurface,
        foregroundColor: MyColors.darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: MyColors.darkOnSurface,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.darkPrimary,
          foregroundColor: MyColors.darkOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MyColors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
          borderSide: const BorderSide(color: MyColors.darkOnSurface, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
          borderSide: const BorderSide(color: MyColors.darkOnSurface, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
          borderSide: const BorderSide(color: MyColors.darkPrimary, width: 2),
        ),
        contentPadding: Values.defaultPaddingSmall,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: MyColors.darkOnSurface),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: MyColors.darkOnSurface),
        bodyLarge: TextStyle(fontSize: 16, color: MyColors.darkOnSurface),
        bodyMedium: TextStyle(fontSize: 14, color: MyColors.darkOnSurface),
      ),
    );
  }
}
