import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/components/form_button.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(Strings.recordPayment),
        ),
        body: Form(
          key: controller.formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: Values.defaultPadding,
                decoration: Styles.expenseContainerDecoration,
                child: Column(
                  children: [
                    const SizedBox(height: Values.defaultHorizontalGap),
                    AmountTextField(
                      textController: controller.paymentAmountController,
                      textStyle: Styles.headerAmountStyle,
                    ),
                    const SizedBox(height: Values.defaultVerticalGap * 2),
                  ],
                ),
              ),
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
              FormButton(
                onPressed: controller.onSaveClicked,
                text: Strings.save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
