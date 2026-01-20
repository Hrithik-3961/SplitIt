import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';

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
    return Dialog(
      child: Padding(
        padding: Values.defaultPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: Values.defaultHorizontalGap,
          children: [
            Text(
              Strings.addExpense,
              style: Get.textTheme.displaySmall,
            ),
            const Text(Strings.enterAmount),
            Center(
                child: Form(
              key: widget.formKey,
              child: SizedBox(
                width: double.maxFinite,
                height: Values.dialogHeight,
                child: Center(
                  child: AmountTextField(
                    textController: widget.textController,
                    focusNode: _focusNode,
                    textStyle: Get.textTheme.displayLarge,
                  ),
                ),
              ),
            )),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: widget.onPressed,
                    child: const Text(Strings.add)))
          ],
        ),
      ),
    );
  }
}
