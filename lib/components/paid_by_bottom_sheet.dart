import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/components/base_bottom_sheet.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

class PaidByBottomSheet extends GetView<AddExpenseController> {
  final List<UserExpenseData> userExpenseDataList;
  final double totalAmount;

  const PaidByBottomSheet(
      {super.key,
      required this.userExpenseDataList,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {

    return BaseBottomSheet(
      showSecondary: false.obs,
      primaryChildren: [
        Obx(() {
          final allSelectedUsers = userExpenseDataList
              .where((u) => u.isPaidBySelected.value)
              .toList();
          final nonManuallyEditedSelectedUsers = allSelectedUsers
              .where((u) => !u.isPaidByManuallyEdited)
              .toList();
          final lastUser = nonManuallyEditedSelectedUsers.isNotEmpty
              ? nonManuallyEditedSelectedUsers.last
              : null;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, item) {
              final data = userExpenseDataList[item];
              final isSelected = data.isPaidBySelected;
              final isLast = data == lastUser;
              final isEnabled = isSelected.value && !isLast;

              return ListTile(
                leading: Checkbox(
                    value: isSelected.value,
                    onChanged: (value) {
                      isSelected.toggle();
                      controller.onPaidByAmountChanged(data, false);
                    }),
                title: Text(data.user.name),
                trailing: AmountTextField(
                  textController: isLast && allSelectedUsers.length > 1
                      ? TextEditingController(text: Strings.remainder)
                      : data.paidByController,
                  enabled: isEnabled,
                  onChanged: (_) =>
                      controller.onPaidByAmountChanged(data, true),
                  fullWidth: false,
                  textStyle: !isEnabled ? Styles.disabledTextStyle : null,
                ),
              );
            },
            itemCount: userExpenseDataList.length,
          );
        }),
      ],
    );
  }
}
