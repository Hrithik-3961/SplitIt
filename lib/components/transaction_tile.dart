import 'package:flutter/material.dart';
import 'package:splitit/constants/colors.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/my_transaction.dart';

import '../enums/transaction_type.dart';

class TransactionTile extends StatelessWidget {
  final MyTransaction transaction;
  final VoidCallback onTap;

  const TransactionTile(
      {super.key, required this.transaction, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isPayment = transaction.transactionType == TransactionType.payment;

    return Card(
      margin: Values.defaultMarginSmall,
      elevation: 0,
      color: Colors.transparent,
      child: ListTile(
        onTap: onTap,
        contentPadding: Values.defaultContentPadding,
        leading: Container(
          padding: Values.defaultPaddingSmall,
          decoration: BoxDecoration(
            color: (isPayment ? MyColors.success : MyColors.info).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isPayment ? Icons.payment : Icons.receipt_long,
            color: isPayment ? MyColors.success : MyColors.info,
          ),
        ),
        title: Text(
          isPayment ? "${Strings.from}: ${transaction.title}" : transaction.title,
          style: Styles.titleStyle,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPayment ? "${Strings.to}: ${transaction.subtitle}" : "${Strings.paidBy}: ${transaction.subtitle}",
              style: Styles.subtitleStyle,
            ),
            const SizedBox(height: 2),
          ],
        ),
        trailing: Text(
          transaction.totalAmount,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
