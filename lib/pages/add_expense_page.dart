import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/user_tile.dart';
import 'package:splitit/constants/strings.dart';
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  controller.amountString,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
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
                  child: ListView.separated(
                    itemBuilder: (context, item) {
                      final data = controller.userExpenseDataList[item];
                      return UserTile(
                        user: data.user,
                        textController: data.controller,
                        focusNode: data.focusNode,
                        isSelected: data.isSelected,
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: controller.userExpenseDataList.length,
                  ),
                ),
                Padding(
                  padding: Values.defaultPadding,
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {},
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
