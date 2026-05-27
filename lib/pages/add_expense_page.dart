import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/action_page_layout.dart';
import 'package:splitit/components/user_tile.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

import '../enums/split_type.dart';
import '../models/my_transaction.dart';

class AddExpensePage extends GetView<AddExpenseController> {
  const AddExpensePage({super.key});

  static const String route = "/addExpense";

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.amountString.isNotEmpty && (Get.arguments is MyTransaction);
    return ActionPageLayout(
      title: isEditing ? Strings.edit : Strings.addExpense,
      formKey: controller.formKey,
      buttonText: isEditing ? Strings.save : Strings.sendRequest,
      onButtonPressed: () {
        if (controller.formKey.currentState!.validate()) {
          controller.onSendRequest();
        }
      },
      header: Column(
        children: [
          Text(
            controller.amountString,
            style: Styles.headerAmountStyle,
          ),
          const SizedBox(height: Values.defaultVerticalGap),
          Container(
            padding: Values.defaultPadding,
            decoration: Styles.expenseTitleContainerDecoration,
            child: TextFormField(
              controller: controller.expenseTitleController,
              decoration: Styles.expenseTitleDecoration,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: Values.defaultPaddingMedium,
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet_outlined,
                    size: Values.smallIconSize, color: MyColors.hint),
                const SizedBox(width: Values.defaultHorizontalGap),
                const Text(Strings.paidBy,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Values.smallTextSize)),
                const SizedBox(width: Values.defaultHorizontalGap * 2),
                ActionChip(
                  onPressed: controller.onPaidByClicked,
                  label: Obx(() {
                    String paidBy = controller.paidByText.value;
                    return Text(
                      paidBy.isEmpty ? Strings.select : paidBy,
                      style: TextStyle(
                        color: paidBy.isEmpty
                            ? MyColors.hint
                            : Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  backgroundColor: Get.theme.primaryColor.withValues(alpha: 0.1),
                  side: BorderSide.none,
                ),
                const Spacer(),
                Obx(
                  () => Container(
                    padding: Values.defaultMargin,
                    decoration: Styles.splitOptionDecoration,
                    child: DropdownButton<SplitType>(
                      value: controller.splitOption.value,
                      underline: const SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: controller.splitOptions
                          .map((option) => DropdownMenuItem<SplitType>(
                              value: option,
                              child: Text(option.value,
                                  style: const TextStyle(
                                      fontSize: Values.smallTextSize))))
                          .toList(),
                      onChanged: (newValue) {
                        controller.splitOption.value = newValue!;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: Values.defaultPaddingSmall,
            child: Divider(),
          ),
          Expanded(
            child: Obx(() {
              final _ = controller.updateTrigger.value;
              return ListView.separated(
                padding: Values.defaultPaddingMedium,
                itemBuilder: (context, item) {
                  final data = controller.userExpenseDataList[item];
                  return UserTile(
                    user: data.user,
                    amountController: data.splitAmountController,
                    shareController: data.shareController,
                    percentageController: data.percentageController,
                    amountFocusNode: data.amountFocusNode,
                    shareFocusNode: data.shareFocusNode,
                    percentageFocusNode: data.percentageFocusNode,
                    isSelected: data.isPaidForSelected,
                    isAmountManuallyEditable:
                        controller.isAmountManuallyEditable,
                    isSharesEditable: controller.isSharesEditable,
                    isPercentageEditable: controller.isPercentageEditable,
                    onPercentageChanged: (_) =>
                        controller.onPercentageChanged(data),
                    onAmountChanged: (_) => controller.onAmountChanged(data),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: Values.defaultHorizontalGap),
                itemCount: controller.userExpenseDataList.length,
              );
            }),
          ),
        ],
      ),
    );
  }
}
