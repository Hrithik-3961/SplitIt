import 'package:flutter/material.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/utils/common_validator.dart';

class NameFormField extends StatelessWidget {
  final TextEditingController controller;
  final InputDecoration inputDecoration;
  final bool readOnly;

  const NameFormField(
      {super.key,
      required this.controller,
      required this.inputDecoration,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      autofocus: true,
      decoration: inputDecoration,
      keyboardType: TextInputType.name,
      maxLength: 20,
      validator: CommonValidator.validateName,
      inputFormatters: Styles.nameInputFormatters,
      textCapitalization: TextCapitalization.words,
    );
  }
}
