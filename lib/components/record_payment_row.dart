import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/models/group_members.dart';
import '../constants/styles.dart';
import '../constants/values.dart';

class RecordPaymentRow extends StatelessWidget {
  final String label;
  final RxString initialValue;
  final List<GroupMembers> users;

  const RecordPaymentRow(
      {super.key,
      required this.initialValue,
      required this.users,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Values.defaultPaddingMedium,
      decoration: Styles.cardDecoration,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: MyColors.hint),
            ),
          ),
          const SizedBox(
            width: Values.defaultHorizontalGap,
          ),
          Expanded(
            flex: 4,
            child: Obx(
              () => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: initialValue.value.isEmpty ? null : initialValue.value,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: users
                        .map((u) => DropdownMenuItem(
                            value: u.uid,
                            child: Text(
                              u.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                              ),
                            )))
                        .toList(),
                    onChanged: (newValue) {
                      initialValue.value = newValue!;
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }
}
