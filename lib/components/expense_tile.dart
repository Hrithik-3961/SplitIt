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
        title: Text(expense.title),
        trailing: Text(
          "${expense.amount > 0 ? "+" : "-"} ${expense.amount.abs()}",
          style: TextStyle(
              color: expense.amount > 0 ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
