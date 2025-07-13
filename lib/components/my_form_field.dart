import 'package:flutter/material.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';

class MyFormField {
  static List<Widget> defaultForm({required String label, required String hint}) => [
    Text(
      label,
      style: Styles.defaultTextStyle,
    ),
    const SizedBox(
      height: Values.defaultGap,
    ),
    TextFormField(
      decoration: Styles.getFormDecoration(hint),
    ),
    const SizedBox(
      height: 2 * Values.defaultGap,
    ),
  ];
}