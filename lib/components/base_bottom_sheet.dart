import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';

class BaseBottomSheet extends StatelessWidget {
  final List<Widget> primaryChildren;
  final List<Widget>? secondaryChildren;
  final String? primaryTitle;
  final String? secondaryTitle;
  final RxBool showSecondary;
  final GlobalKey<FormState>? formKey;
  final EdgeInsets? padding;

  const BaseBottomSheet({
    super.key,
    required this.primaryChildren,
    required this.showSecondary,
    this.secondaryChildren,
    this.primaryTitle,
    this.secondaryTitle,
    this.formKey,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? Values.defaultPadding,
      decoration: Styles.paidByBottomSheetDecoration,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Obx(() {
            final isSecondary = showSecondary.value;
            final currentTitle = isSecondary ? (secondaryTitle ?? primaryTitle) : primaryTitle;
            final currentChildren = isSecondary ? (secondaryChildren ?? []) : primaryChildren;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentTitle != null) ...[
                  const SizedBox(height: Values.defaultHorizontalGap * 2),
                  Text(
                    currentTitle,
                    style: Get.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: Values.defaultHorizontalGap * 2),
                ],
                AnimatedSwitcher(
                  duration: Values.mediumAnimationDuration,
                  child: Column(
                    key: ValueKey(isSecondary),
                    mainAxisSize: MainAxisSize.min,
                    children: currentChildren,
                  ),
                ),
                const SizedBox(height: Values.defaultVerticalGap),
              ],
            );
          }),
        ),
      ),
    );
  }
}
