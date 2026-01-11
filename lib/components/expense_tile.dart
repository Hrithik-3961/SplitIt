import 'package:flutter/material.dart';
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
        titleTextStyle: Theme.of(context).textTheme.titleLarge,
        subtitle: Text(expense.paidBy),
        subtitleTextStyle: Theme.of(context).textTheme.titleMedium,
        trailing: Text(expense.amount),
        leadingAndTrailingTextStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
