import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/my_transaction.dart';

import '../enums/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  final MyTransaction transaction;
  final VoidCallback onTap;

  const TransactionTile(
      {super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(transaction.transactionType == TransactionType.payment
            ? Icons.money
            : Icons.attach_money),
        title: Text.rich(TextSpan(
            text:
                "${transaction.transactionType == TransactionType.payment ? Strings.from : ""} ",
            style: TextStyle(color: Get.theme.hintColor),
            children: [
              TextSpan(
                  text: transaction.title,
                  style: TextStyle(color: Get.theme.colorScheme.onSurface))
            ]),
        ),
        titleTextStyle: Get.textTheme.titleLarge,
        subtitle: Text.rich(TextSpan(
            text:
            "${transaction.transactionType == TransactionType.payment ? Strings.to : transaction.subtitle} ",
            style: TextStyle(color: Get.theme.hintColor),
            children: transaction.transactionType == TransactionType.payment ? [
              TextSpan(
                  text: transaction.subtitle,
                  style: TextStyle(color: Get.theme.colorScheme.onSurface))
            ] : []),
        ),
        subtitleTextStyle: Get.textTheme.titleMedium,
        trailing: Text(transaction.totalAmount),
        leadingAndTrailingTextStyle: Get.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
