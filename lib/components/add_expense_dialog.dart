import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/utils/expense_validator.dart';

class AddExpenseDialog extends StatelessWidget {
  const AddExpenseDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text(Strings.addExpense),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(Strings.enterAmount),
          Form(
              key: formKey,
              child: Center(
                child: IntrinsicWidth(
                  child: TextFormField(
                    controller: controller,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: Styles.amountTextStyle,
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
                ),
              ))
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Get.back(result: controller.text);
              }
            },
            child: const Text(Strings.add))
      ],
    );
  }
}
