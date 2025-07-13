import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:splitit/constants/strings.dart';

import 'package:splitit/constants/values.dart';

class Styles {

  static get defaultTextStyle => const TextStyle(fontSize: Values.defaultTextSize);

  static get amountTextStyle => const TextStyle(fontSize: Values.largeTextSize);

  static get expenseInputDecoration => InputDecoration(
      hintText: toCurrencyString(
        "",
        leadingSymbol: Strings.rupeeSign,
        useSymbolPadding: true,
      ),
      border: InputBorder.none);

  static InputDecoration getFormDecoration(String hint) => InputDecoration(
      hintText: hint, filled: true, border: InputBorder.none
  );
}
