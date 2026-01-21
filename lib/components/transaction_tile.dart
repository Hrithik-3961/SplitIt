import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionTile(
      {super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(transaction.type == TransactionType.payment
            ? Icons.money
            : Icons.attach_money),
        title: Text.rich(TextSpan(
            text:
                "${transaction.type == TransactionType.payment ? Strings.from : ""} ",
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
            "${transaction.type == TransactionType.payment ? Strings.to : transaction.subtitle} ",
            style: TextStyle(color: Get.theme.hintColor),
            children: transaction.type == TransactionType.payment ? [
              TextSpan(
                  text: transaction.subtitle,
                  style: TextStyle(color: Get.theme.colorScheme.onSurface))
            ] : []),
        ),
        subtitleTextStyle: Get.textTheme.titleMedium,
        trailing: Text(transaction.amount),
        leadingAndTrailingTextStyle: Get.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
