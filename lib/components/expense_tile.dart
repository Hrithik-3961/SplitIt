import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const ExpenseTile({super.key, required this.expense, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: const Icon(Icons.attach_money),
        title: Text(expense.title),
        titleTextStyle: Get.textTheme.titleLarge,
        subtitle: Text(expense.paidBy),
        subtitleTextStyle: Get.textTheme.titleMedium,
        trailing: Text(expense.amount),
        leadingAndTrailingTextStyle: Get.textTheme.bodyMedium,
      ),
    );
  }
}
