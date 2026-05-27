import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/transaction_icon.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/transaction_details_controller.dart';
import 'package:splitit/enums/icon_size.dart';
import 'package:splitit/utils/base_util.dart';

import '../enums/transaction_type.dart';

class TransactionDetailsPage extends GetView<TransactionDetailsController> {
  const TransactionDetailsPage({super.key});

  static const String route = "/transactionDetails";

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.transactionDetails),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: controller.onBack,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: controller.onEditClicked,
            ),
          ],
        ),
        body: Obx(() {
          final tx = controller.transaction.value;
          final isPayment = tx.transactionType == TransactionType.payment;

          return SingleChildScrollView(
            padding: Values.defaultPaddingLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      TransactionIcon(isPayment: isPayment, iconSize: IconSize.large,),
                      const SizedBox(height: Values.defaultVerticalGap),
                      Text(
                        tx.title,
                        style: Get.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        tx.totalAmount,
                        style: Styles.headerAmountStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Values.defaultVerticalGap),
                const Divider(),
                const SizedBox(height: Values.defaultVerticalGap),
                Text(
                  Strings.paidBy,
                  style: Get.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ...tx.paidMap.entries.map((entry) {
                  if (entry.value == 0) return const SizedBox();
                  return Padding(
                    padding: Values.defaultPaddingSmall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.getMemberName(entry.key)),
                        Text(BaseUtil.getFormattedCurrency(
                            entry.value.toString())),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: Values.defaultVerticalGap * 2),
                Text(
                  isPayment ? Strings.to : Strings.splitBetween,
                  style: Get.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ...tx.owedMap.entries.map((entry) {
                  if (entry.value == 0) return const SizedBox();
                  return Padding(
                    padding: Values.defaultPaddingSmall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.getMemberName(entry.key)),
                        Text(BaseUtil.getFormattedCurrency(
                            entry.value.toString())),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ),
    );
  }
}
