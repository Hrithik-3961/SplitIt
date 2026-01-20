import 'package:flutter/material.dart';

import '../constants/values.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const FormButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Values.bottomPadding,
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
            onPressed: onPressed,
            child: Text(text)),
      ),
    );
  }
}
