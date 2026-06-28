import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirmed;

  const ConfirmationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.confirmText,
      required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(Strings.cancel),
        ),
        TextButton(
          onPressed: onConfirmed,
          child: Text(confirmText, style: const TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
