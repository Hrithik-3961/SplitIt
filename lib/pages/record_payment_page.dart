import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/action_page_layout.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/constants/styles.dart';
import 'package:splitit/controllers/record_payment_controller.dart';

import '../components/record_payment_row.dart';
import '../constants/strings.dart';
import '../constants/values.dart';

class RecordPaymentPage extends GetView<RecordPaymentController> {
  const RecordPaymentPage({super.key});

  static const String route = "/recordPayment";

  @override
  Widget build(BuildContext context) {
    return ActionPageLayout(
      title: Strings.recordPayment,
      formKey: controller.formKey,
      buttonText: Strings.save,
      onButtonPressed: controller.onSaveClicked,
      header: Column(
        children: [
          const SizedBox(height: Values.defaultHorizontalGap),
          AmountTextField(
            textController: controller.paymentAmountController,
            textStyle: Styles.headerAmountStyle,
          ),
          const SizedBox(height: Values.defaultVerticalGap * 2),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: Values.defaultPaddingLarge,
            child: Column(
              children: [
                RecordPaymentRow(
                  initialValue: controller.paidFromUserId,
                  users: controller.paidFromUsers,
                  label: Strings.from,
                ),
                const SizedBox(
                  height: Values.defaultVerticalGap,
                ),
                RecordPaymentRow(
                  initialValue: controller.paidToUserId,
                  users: controller.paidToUsers,
                  label: Strings.to,
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
