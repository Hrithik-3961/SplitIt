import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/utils/base_util.dart';

class Styles {
  static get phoneNumberInputDecoration => InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: Strings.phoneNumber,
        prefixText: Strings.phoneNumberPrefix,
        prefixIcon: const Icon(Icons.phone),
        prefixStyle: Get.textTheme.bodyMedium,
        hintText: Strings.phoneNumberHint,
        hintStyle: Get.textTheme.bodyMedium?.copyWith(
          color: Get.theme.hintColor,
        ),
      );

  static get nameInputDecoration => InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    labelText: Strings.name,
    prefixIcon: const Icon(Icons.person_outline),
    prefixStyle: Get.textTheme.bodyMedium,
    hintText: Strings.nameHint,
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

  static get expenseContainerDecoration => BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(Values.borderRadius * 3)),
      );

  static get expenseTitleContainerDecoration => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(Values.borderRadius),
      );

  static get expenseTitleDecoration => InputDecoration(
        isDense: true,
        filled: true,
        fillColor: Get.theme.colorScheme.surface,
        hintText: Strings.expenseTitleHintText,
        contentPadding: Values.defaultPaddingSmall,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Values.borderRadius),
            borderSide: BorderSide.none),
        hintStyle: TextStyle(color: Get.theme.hintColor),
      );

  static get splitOptionDecoration => BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Values.borderRadius),
      );

  static get defaultTextInputStyle => Get.textTheme.bodyMedium;

  static get disabledTextStyle =>
      defaultTextInputStyle.copyWith(color: Get.theme.disabledColor);

  static get paidByBottomSheetDecoration => BoxDecoration(
        color: Get.theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(Values.borderRadius * 2)),
      );

  static get expenseInputDecoration => InputDecoration(
        isDense: true,
        hintText: BaseUtil.getFormattedCurrency(""),
        border: const UnderlineInputBorder(),
        errorMaxLines: 2,
        contentPadding: Values.defaultContentPadding,
      );

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

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(Values.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static TextStyle get headerAmountStyle => const TextStyle(
        fontSize: Values.largeTextSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get titleStyle => TextStyle(
        fontSize: Values.defaultTextSize,
        fontWeight: FontWeight.w600,
        color: Get.theme.colorScheme.onSurface,
      );

  static TextStyle get subtitleStyle => const TextStyle(
        fontSize: Values.defaultTextSize,
        color: MyColors.hint,
      );

  static TextStyle get codeTextStyle => const TextStyle(
    fontSize: Values.mediumTextSize,
    fontWeight: FontWeight.bold,
    letterSpacing: 2,
  );
}
