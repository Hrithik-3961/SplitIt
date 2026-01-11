import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';

import 'package:splitit/utils/base_util.dart';

class Styles {
  static get expenseTitleDecoration => InputDecoration(
    isDense: true,
      filled: true,
      fillColor: Theme.of(Get.context!).colorScheme.surface,
      hintText: Strings.expenseTitleHintText,
      contentPadding: Values.defaultPaddingSmall,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: MyColors.hint));

  static get expenseInputDecoration => InputDecoration(
      hintText: BaseUtil.getFormattedCurrency(""), border: InputBorder.none);

  static get shareInputDecoration => const InputDecoration(
        isDense: true,
        border: UnderlineInputBorder(),
      );

  static get sharesInputFormatters => [
        FilteringTextInputFormatter.digitsOnly,
      ];

  static get percentageInputDecoration => shareInputDecoration.copyWith(
        suffixText: '%',
      );

  static get percentageInputFormatters => [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      ];
}
