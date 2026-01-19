import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

class PaidByBottomSheet extends StatelessWidget {
  final List<UserExpenseData> userExpenseDataList;
  final double totalAmount;

  const PaidByBottomSheet(
      {super.key,
      required this.userExpenseDataList,
      required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final addExpenseController = Get.find<AddExpenseController>();

    return Container(
      height: Get.height * 0.4,
      width: double.infinity,
      padding: Values.defaultPadding,
      decoration: Styles.paidByBottomSheetDecoration,
      child: Obx(() {
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
                    addExpenseController.onPaidByAmountChanged(data, false);
                  }),
              title: Text(data.user.name),
              trailing: AmountTextField(
                textController: isLast && allSelectedUsers.length > 1
                    ? TextEditingController(text: Strings.remainder)
                    : data.paidByController,
                enabled: isEnabled,
                onChanged: (_) =>
                    addExpenseController.onPaidByAmountChanged(data, true),
                fullWidth: false,
                textStyle: !isEnabled ? Get.textTheme.bodyMedium?.copyWith(color: Theme.of(context).disabledColor) : null,
              ),
            );
          },
          itemCount: userExpenseDataList.length,
        );
      }),
    );
  }
}
