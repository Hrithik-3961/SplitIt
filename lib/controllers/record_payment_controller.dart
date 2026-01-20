import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/record_payment_service.dart';
import 'package:splitit/utils/base_util.dart';

import '../models/transaction.dart';

class RecordPaymentController extends GetxController{
  late final RecordPaymentService _recordPaymentService;
  late final List<User> _users;

  late final paidFromUserId = _users.first.id.obs;
  late final paidToUserId = _users.first.id.obs;

  get formKey => _formKey;
  List<User> get users => _users;
  get paymentAmountController => _paymentAmountController;

  final _formKey = GlobalKey<FormState>();
  final _paymentAmountController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _recordPaymentService = Get.put(RecordPaymentService());
    _users = _recordPaymentService.members;
  }

  void onSaveClicked() {
    if (_formKey.currentState!.validate()) {

      User paidFrom = _users.firstWhere((u) => u.id == paidFromUserId.value);
      User paidTo = _users.firstWhere((u) => u.id == paidToUserId.value);
      double amount = BaseUtil.getNumericValue(_paymentAmountController.text) ?? 0;

      _recordPaymentService.savePayment(paidFrom: paidFrom, paidTo: paidTo, amount: amount);

      Get.back(result: Transaction(title: paidFrom.name, amount: _paymentAmountController.text, paidBy: paidTo.name, type: TransactionType.payment));
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