import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/record_payment_service.dart';

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
}

class RecordPaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordPaymentController());
  }
}