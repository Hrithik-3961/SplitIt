import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/add_expense_service.dart';
import 'package:splitit/utils/base_util.dart';

class UserExpenseData {
  final User user;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxBool isSelected = true.obs;

  UserExpenseData({required this.user});

  void dispose() {
    controller.dispose();
    focusNode.dispose();
  }
}

class AddExpenseController extends GetxController {
  late AddExpenseService _addExpenseService;

  List<String> get splitOptions => _addExpenseService.splitOptions;

  late final String amountString;

  get formKey => _formKey;

  late final List<UserExpenseData> userExpenseDataList;

  late final splitOption = splitOptions.first.obs;

  double get _totalAmount => BaseUtil.getNumericValue(amountString) ?? 0.0;

  final _formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    amountString = Get.arguments ?? "";
    _addExpenseService = Get.put(AddExpenseService());
    userExpenseDataList = _addExpenseService.members
        .map((user) => UserExpenseData(user: user))
        .toList();
  }

  @override
  void onClose() {
    for (var data in userExpenseDataList) {
      data.dispose();
    }
    super.onClose();
  }
}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseController(), fenix: true);
  }
}
