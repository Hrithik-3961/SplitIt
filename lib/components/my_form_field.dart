import 'package:flutter/material.dart';
import 'package:splitit/constants/themes.dart';
import 'package:splitit/constants/values.dart';

class MyFormField {
  static List<Widget> defaultForm({required String label, required String hint}) => [
    Text(
      label,
      style: const TextStyle(fontSize: Values.defaultTextSize),
    ),
    const SizedBox(
      height: Values.defaultGap,
    ),
    TextFormField(
      decoration: Themes.getFormDecoration(hint),
    ),
    const SizedBox(
      height: 2 * Values.defaultGap,
    ),
  ];
}