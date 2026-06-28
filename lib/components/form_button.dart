import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/values.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool enabled;
  final bool isLoading;

  const FormButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.enabled = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: AnimatedContainer(
            duration: Values.mediumAnimationDuration,
            curve: Curves.easeInOut,
            width: isLoading ? Values.formButtonSize : constraints.maxWidth,
            height: Values.formButtonSize,
            child: AnimatedSwitcher(
              duration: Values.mediumAnimationDuration,
              child: isLoading
                  ? Center(
                      key: const ValueKey('loading'),
                      child: CircularProgressIndicator(
                        color: Get.theme.primaryColor,
                      ),
                    )
                  : SizedBox(
                      key: const ValueKey('button'),
                      width: double.infinity,
                      height: Values.formButtonSize,
                      child: ElevatedButton(
                        onPressed: enabled ? onPressed : null,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Values.borderRadius)),
                          backgroundColor: enabled
                              ? Get.theme.primaryColor
                              : Get.theme.disabledColor,
                        ),
                        child: Text(
                          text,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: Values.defaultTextSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
