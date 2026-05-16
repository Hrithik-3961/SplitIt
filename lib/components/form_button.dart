import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';

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
      padding: Values.defaultPadding,
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Values.borderRadius)),
            backgroundColor: enabled == true
                ? Get.theme.primaryColor
                : Get.theme.disabledColor,
          ),
          child: const Text(
            Strings.sendRequest,
            style: TextStyle(fontSize: Values.defaultTextSize, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
