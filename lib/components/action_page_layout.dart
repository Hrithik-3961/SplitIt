import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/form_button.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';

class ActionPageLayout extends StatelessWidget {
  final String title;
  final GlobalKey<FormState> formKey;
  final Widget header;
  final Widget body;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const ActionPageLayout({
    super.key,
    required this.title,
    required this.formKey,
    required this.header,
    required this.body,
    required this.buttonText,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          centerTitle: true,
          title: Text(title),
        ),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: Values.defaultPaddingLarge,
                decoration: Styles.expenseContainerDecoration,
                child: header,
              ),
              Expanded(
                child: body,
              ),
              Padding(
                padding: Values.defaultPadding,
                child: FormButton(
                  onPressed: onButtonPressed,
                  text: buttonText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
