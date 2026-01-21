import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';

class EditPhoneNumberDialog extends StatelessWidget {
  final String text;
  final VoidCallback onPositiveBtnPressed;

  const EditPhoneNumberDialog(
      {super.key, required this.text, required this.onPositiveBtnPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        text,
        style: Get.textTheme.titleMedium,
      ),
      actions: [
        TextButton(
          onPressed: onPositiveBtnPressed,
          child: const Text(Strings.yes),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(Strings.cancel),
        )
      ],
    );
  }
}
