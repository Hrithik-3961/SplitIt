import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/add_expense_service.dart';
import 'package:splitit/utils/base_util.dart';

class AddExpenseController extends GetxController {

  late AddExpenseService _addExpenseService;
  List<String> get splitOptions => _addExpenseService.splitOptions;
  List<User> get members => _addExpenseService.members;
  String get amountString => Get.arguments ?? "";

  get formKey => _formKey;

  late final splitOption = splitOptions.first.obs;
  late final _totalAmount = BaseUtil.getNumericValue(amountString);

  final _formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _addExpenseService = Get.put(AddExpenseService());
  }

}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseController());
  }

}