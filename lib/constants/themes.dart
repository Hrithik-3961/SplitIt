import 'package:flutter/material.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/values.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: MyColors.lightPrimary,
      disabledColor: MyColors.hint,
      colorScheme: const ColorScheme.light(
        primary: MyColors.lightPrimary,
        secondary: MyColors.lightAccent,
        surface: MyColors.lightSurface,
        onPrimary: MyColors.lightOnPrimary,
        onSecondary: MyColors.lightOnBackground,
        onSurface: MyColors.lightOnBackground,
        error: MyColors.error,
        onError: MyColors.onError,
      ),
      scaffoldBackgroundColor: MyColors.lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.lightPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.lightOnPrimary),
        titleTextStyle: TextStyle(
          color: MyColors.lightOnPrimary,
          fontSize: Values.defaultTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.lightOnPrimary,
          backgroundColor: MyColors.lightPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(MyColors.lightOnPrimary),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MyColors.lightPrimary;
          }
          return null;
        }),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: Values.defaultTextSize),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: MyColors.darkPrimary,
      disabledColor: MyColors.hint,
      colorScheme: const ColorScheme.dark(
        primary: MyColors.darkPrimary,
        secondary: MyColors.darkAccent,
        surface: MyColors.darkSurface,
        onPrimary: MyColors.darkOnPrimary,
        onSecondary: MyColors.darkOnBackground,
        onSurface: MyColors.darkOnBackground,
        error: MyColors.error,
        onError: MyColors.onError,
      ),
      scaffoldBackgroundColor: MyColors.darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: MyColors.darkSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: MyColors.darkOnBackground),
        titleTextStyle: TextStyle(
          color: MyColors.darkOnBackground,
          fontSize: Values.defaultTextSize,
          fontWeight: FontWeight.bold,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: MyColors.darkOnPrimary,
          backgroundColor: MyColors.darkPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        checkColor: WidgetStateProperty.all(MyColors.darkOnPrimary),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return MyColors.darkPrimary;
          }
          return null;
        }),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: Values.defaultTextSize),
      ),
    );
  }
}
