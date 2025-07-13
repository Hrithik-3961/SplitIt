import 'package:flutter/material.dart';

import 'package:splitit/constants/values.dart';
import 'package:splitit/utils/base_util.dart';

class Styles {
  static get defaultTextStyle =>
      const TextStyle(fontSize: Values.defaultTextSize);

  static get expenseTextStyle =>
      const TextStyle(fontSize: Values.largeTextSize);

  static get expenseInputDecoration => InputDecoration(
      hintText: BaseUtil.getFormattedCurrency(""), border: InputBorder.none);

  static InputDecoration getFormDecoration(String hint) =>
      InputDecoration(hintText: hint, filled: true, border: InputBorder.none);
}
