import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
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
      height: 300,
      width: double.infinity,
      padding: Values.defaultPadding,
      decoration: Styles.paidByBottomSheetDecoration,
      child: ListView.builder(
        itemBuilder: (context, item) {
          final data = userExpenseDataList[item];
          final RxBool isSelected = data.isPaidBySelected;

          return Obx(
            () => ListTile(
              leading: Checkbox(
                  value: isSelected.value,
                  onChanged: (value) {
                    isSelected.toggle();
                    addExpenseController.onPaidByChanged(data);
                  }),
              title: Text(data.user.name),
              trailing: AmountTextField(
                textController: data.paidByController,
                enabled: isSelected.value,
                onChanged: (_) => addExpenseController.onPaidByChanged(data),
                fullWidth: false,
              ),
            ),
          );
        },
        itemCount: userExpenseDataList.length,
      ),
    );
  }
}
