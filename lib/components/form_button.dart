import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/values.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool? enabled;

  const FormButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Values.bottomPadding,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(
              backgroundColor: enabled == true
                  ? Get.theme.primaryColor
                  : Get.theme.disabledColor,
            ),
            child: Text(text)),
      ),
    );
  }
}
