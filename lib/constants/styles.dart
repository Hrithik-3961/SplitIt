import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';

import 'package:splitit/utils/base_util.dart';

class Styles {
  static get phoneNumberInputDecoration => InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: Strings.phoneNumber,
        prefixText: Strings.phoneNumberPrefix,
        prefixStyle: Get.textTheme.bodyMedium,
        hintText: Strings.phoneNumberHint,
        hintStyle: Get.textTheme.bodyMedium?.copyWith(
          color: Get.theme.hintColor,
        ),
      );

  static get phoneNumberInputFormatters => [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(Values.phoneNumberLength),
      ];

  static get otpInputFormatters => [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(Values.otpLength),
  ];

  static get expenseTitleDecoration => InputDecoration(
      isDense: true,
      filled: true,
      fillColor: Get.theme.colorScheme.surface,
      hintText: Strings.expenseTitleHintText,
      contentPadding: Values.defaultPaddingSmall,
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
      hintStyle: TextStyle(color: Get.theme.hintColor));

  static get defaultTextInputStyle => Get.textTheme.bodyMedium;

  static get disabledTextStyle =>
      defaultTextInputStyle.copyWith(color: Get.theme.disabledColor);

  static get paidByBottomSheetDecoration => BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      );

  static get expenseInputDecoration => InputDecoration(
        hintText: BaseUtil.getFormattedCurrency(""),
        border: const UnderlineInputBorder(),
        errorMaxLines: 2,
      );

  static get shareInputDecoration => const InputDecoration(
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
