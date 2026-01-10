import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/utils/expense_validator.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController textController;
  final bool enabled;
  final FocusNode? focusNode;
  final TextStyle? _textStyle;

  const AmountTextField(
      {super.key,
      required this.textController,
      this.enabled = true,
      this.focusNode,
      TextStyle? textStyle}) : _textStyle = textStyle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextFormField(
        controller: textController,
        enabled: enabled,
        focusNode: focusNode,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: _textStyle ?? Theme.of(context).textTheme.bodyMedium,
        decoration: Styles.expenseInputDecoration,
        inputFormatters: [
          CurrencyInputFormatter(
            leadingSymbol: Strings.rupeeSign,
            useSymbolPadding: true,
          )
        ],
        validator: (value) => ExpenseValidator.validateAmount(value),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
