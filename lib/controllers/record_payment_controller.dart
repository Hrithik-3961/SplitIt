import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:splitit/services/record_payment_service.dart';

import '../models/my_transaction.dart';

class RecordPaymentController extends GetxController {
  late final RecordPaymentService _recordPaymentService;

  get formKey => _formKey;
  get paymentAmountController => _paymentAmountController;

  get paidFromUserId => _recordPaymentService.paidFromMemberId;
  get paidToUserId => _recordPaymentService.paidToMemberId;
  get paidFromUsers => _recordPaymentService.paidFromUsers;
  get paidToUsers => _recordPaymentService.paidToUsers;

  final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _recordPaymentService = Get.put(RecordPaymentService());
    final args = Get.arguments;
    if (args is MyTransaction) {
      _paymentAmountController.text = args.totalAmount;
      _recordPaymentService.paidFromMemberId.value = args.paidMap.keys.first;
      _recordPaymentService.paidToMemberId.value = args.owedMap.keys.first;
    }
  }

  void onSaveClicked() {
    if (_formKey.currentState!.validate()) {
      final args = Get.arguments;
      final id = args is MyTransaction ? args.id : null;
      MyTransaction? transaction = _recordPaymentService.savePayment(
          amountText: _paymentAmountController.text, id: id);
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
