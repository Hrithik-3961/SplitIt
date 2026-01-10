import 'package:flutter/material.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/strings.dart';

class AddExpenseDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textController;
  final VoidCallback onPressed;

  const AddExpenseDialog(
      {super.key,
      required this.formKey,
      required this.textController,
      required this.onPressed});

  @override
  State<AddExpenseDialog> createState() => _AddExpenseDialogState();
}

class _AddExpenseDialogState extends State<AddExpenseDialog> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
            key: widget.formKey,
            child: AmountTextField(
              textController: widget.textController,
              focusNode: _focusNode,
              textStyle: Theme.of(context).textTheme.displayLarge,
            ),
          )),
        ],
      ),
      actions: [
        TextButton(onPressed: widget.onPressed, child: const Text(Strings.add))
      ],
    );
  }
}
