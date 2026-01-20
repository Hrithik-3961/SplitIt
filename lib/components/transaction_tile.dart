import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionTile({super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: const Icon(Icons.attach_money),
        title: Text(transaction.title),
        titleTextStyle: Get.textTheme.titleLarge,
        subtitle: Text(transaction.paidBy),
        subtitleTextStyle: Get.textTheme.titleMedium,
        trailing: Text(transaction.amount),
        leadingAndTrailingTextStyle: Get.textTheme.bodyMedium,
      ),
    );
  }
}
