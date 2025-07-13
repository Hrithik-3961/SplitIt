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
    String amount = Get.arguments ?? "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.addExpense),
      ),
      body: Padding(
        padding: Values.defaultListPadding,
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  amount,
                  style: Styles.amountTextStyle,
                ),
              ),
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
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, item) {
                    final user = controller.members[item];
                    return UserTile(user: user);
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: controller.members.length,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
