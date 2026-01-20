import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import '../constants/styles.dart';
import '../constants/values.dart';

class RecordPaymentRow extends StatelessWidget {
  final String label;
  final RxString initialValue;
  final List<User> users;

  const RecordPaymentRow(
      {super.key,
      required this.initialValue,
      required this.users,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(label)),
        const SizedBox(
          width: Values.defaultHorizontalGap,
        ),
        Expanded(
          flex: 4,
          child: Obx(
            () => DropdownButtonFormField<String>(
                decoration: Styles.expenseTitleDecoration,
                isExpanded: true,
                initialValue: initialValue.value,
                items: users
                    .map((u) => DropdownMenuItem(
                        value: u.id,
                        child: Text(
                          u.name,
                          style: Get.textTheme.labelLarge
                              ?.copyWith(color: Get.theme.primaryColor),
                        )))
                    .toList(),
                onChanged: (newValue) {
                  initialValue.value = newValue!;
                }),
          ),
        )
      ],
    );
  }
}
