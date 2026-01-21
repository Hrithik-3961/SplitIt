import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/amount_text_field.dart';
import 'package:splitit/components/form_button.dart';
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
        body: Padding(
          padding: Values.defaultPadding,
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                AmountTextField(
                  textController: controller.paymentAmountController,
                  textStyle: Get.textTheme.displayLarge,
                ),
                const SizedBox(
                  height: Values.defaultVerticalGap,
                ),
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
                const Spacer(),
                FormButton(
                  onPressed: controller.onSaveClicked,
                  text: Strings.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
