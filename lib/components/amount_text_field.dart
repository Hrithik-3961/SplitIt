import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/utils/expense_validator.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController textController;
  final TextStyle _textStyle;

  AmountTextField(
      {super.key,
      required this.textController,
      TextStyle? textStyle})
      : _textStyle = textStyle ?? Styles.defaultTextStyle;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: TextFormField(
        controller: textController,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: _textStyle,
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
