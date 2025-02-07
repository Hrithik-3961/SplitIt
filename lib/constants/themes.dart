import 'package:flutter/material.dart';
import 'package:splitit/constants/colors.dart';

class Themes {
  static final lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: MyColors.lightBlue, brightness: Brightness.light),
  );

  static final darkTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: MyColors.darkBlue, brightness: Brightness.dark),
  );
}