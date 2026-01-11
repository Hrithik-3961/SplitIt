import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/user_tile.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

class AddExpensePage extends GetView<AddExpenseController> {
  const AddExpensePage({super.key});

  static const String route = "/addExpense";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(Strings.addExpense),
        ),
        body: Padding(
          padding: Values.defaultListPadding,
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                Text(
                  controller.amountString,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                Container(
                  padding: Values.defaultPaddingSmall,
                  width: Get.width * 0.6,
                  child: TextFormField(
                    controller: controller.expenseTitleController,
                    decoration: Styles.expenseTitleDecoration,
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    Obx(
                      () => DropdownButton<String>(
                        value: controller.splitOption.value,
                        items: controller.splitOptions
                            .map((option) => DropdownMenuItem<String>(
                                value: option, child: Text(option)))
                            .toList(),
                        onChanged: (newValue) {
                          controller.splitOption.value = newValue!;
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Obx(() {
                    // Depend on the trigger to rebuild the list
                    final _ = controller.updateTrigger.value;
                    return ListView.separated(
                      itemBuilder: (context, item) {
                        final data = controller.userExpenseDataList[item];
                        return UserTile(
                          user: data.user,
                          amountController: data.amountController,
                          shareController: data.shareController,
                          percentageController: data.percentageController,
                          amountFocusNode: data.amountFocusNode,
                          shareFocusNode: data.shareFocusNode,
                          percentageFocusNode: data.percentageFocusNode,
                          isSelected: data.isSelected,
                          isAmountManuallyEditable: controller.isAmountManuallyEditable,
                          isSharesEditable: controller.isSharesEditable,
                          isPercentageEditable: controller.isPercentageEditable,
                          onPercentageChanged: (_) => controller.onPercentageChanged(data),
                          onAmountChanged: (_) => controller.onAmountChanged(data),
                        );
                      },
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: controller.userExpenseDataList.length,
                    );
                  }
                  )
                ),
                Padding(
                  padding: Values.bottomPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          if (controller.formKey.currentState!.validate()) {
                            controller.onSendRequest();
                          }
                        },
                        child: const Text(Strings.sendRequest)
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
