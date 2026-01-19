import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/utils/expense_validator.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController textController;
  final bool enabled;
  final FocusNode? focusNode;
  final TextStyle? _textStyle;
  final Function(String)? onChanged;
  final bool fullWidth;

  const AmountTextField(
      {super.key,
      required this.textController,
      this.enabled = true,
      this.focusNode,
      this.onChanged,
      this.fullWidth = true,
      TextStyle? textStyle})
      : _textStyle = textStyle;

  @override
  Widget build(BuildContext context) {
    return AutoSizeTextFormField(
      fullwidth: fullWidth,
      controller: textController,
      enabled: enabled,
      focusNode: focusNode,
      onChanged: onChanged,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      style: _textStyle ?? Get.textTheme.bodyMedium,
      decoration: Styles.expenseInputDecoration,
      inputFormatters: [
        CurrencyInputFormatter(
          leadingSymbol: Strings.rupeeSign,
          useSymbolPadding: true,
        )
      ],
      validator: (value) {
        if (!enabled) {
          return null;
        }
        return ExpenseValidator.validateAmount(value);
      },
      autovalidateMode: AutovalidateMode.disabled,
    );
  }
}
