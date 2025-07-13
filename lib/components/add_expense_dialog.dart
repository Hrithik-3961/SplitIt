import 'package:flutter/material.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';

class AddExpenseDialog extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final VoidCallback onPressed;

  const AddExpenseDialog(
      {super.key,
      required this.formKey,
      required this.textController,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(Strings.addExpense),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(Strings.enterAmount),
          Center(
              child: Form(
            key: formKey,
            child: AmountTextField(
              textController: textController,
              textStyle: Styles.expenseTextStyle,
            ),
          )),
        ],
      ),
      actions: [
        TextButton(
            onPressed: onPressed,
            child: const Text(Strings.add))
      ],
    );
  }
}
