import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:splitit/services/record_payment_service.dart';

import '../models/transaction.dart';

class RecordPaymentController extends GetxController {
  late final RecordPaymentService _recordPaymentService;

  get formKey => _formKey;
  get paymentAmountController => _paymentAmountController;

  get paidFromUserId => _recordPaymentService.paidFromUserId;
  get paidToUserId => _recordPaymentService.paidToUserId;
  get paidFromUsers => _recordPaymentService.paidFromUsers;
  get paidToUsers => _recordPaymentService.paidToUsers;

  final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _recordPaymentService = Get.put(RecordPaymentService());
  }

  void onSaveClicked() {
    if (_formKey.currentState!.validate()) {
      Transaction? transaction = _recordPaymentService.savePayment(
          amountText: _paymentAmountController.text);
      if (transaction != null) {
        Get.back(result: transaction);
      }
    }
  }

  @override
  void onClose() {
    _paymentAmountController.dispose();
    super.onClose();
  }
}

class RecordPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordPaymentController());
  }
}
