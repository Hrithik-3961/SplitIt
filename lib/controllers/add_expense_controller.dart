import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/add_expense_service.dart';
import 'package:splitit/utils/base_util.dart';
import 'package:splitit/constants/strings.dart';

class UserExpenseData {
  final User user;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController shareController = TextEditingController(text: '1');
  final TextEditingController percentageController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode shareFocusNode = FocusNode();
  final FocusNode percentageFocusNode = FocusNode();
  final RxBool isSelected = true.obs;

  UserExpenseData({required this.user});

  void dispose() {
    amountController.dispose();
    shareController.dispose();
    percentageController.dispose();
    amountFocusNode.dispose();
    shareFocusNode.dispose();
    percentageFocusNode.dispose();
  }
}

class AddExpenseController extends GetxController {
  late AddExpenseService _addExpenseService;

  List<String> get splitOptions => _addExpenseService.splitOptions;

  late final String amountString;

  get formKey => _formKey;
  TextEditingController get expenseTitleController => _expenseTitleController;

  late final List<UserExpenseData> userExpenseDataList;

  late final splitOption = splitOptions.first.obs;

  double get _totalAmount => BaseUtil.getNumericValue(amountString) ?? 0.0;

  final _formKey = GlobalKey<FormState>();
  final _expenseTitleController = TextEditingController();
  final updateTrigger = 0.obs;

  bool get isSplitByShares => splitOption.value == Strings.splitOptions[1];
  bool get isSplitByPercentage => splitOption.value == Strings.splitOptions[2];
  bool get isSplitUnevenly => splitOption.value == Strings.splitOptions[3];

  bool get isAmountManuallyEditable => isSplitUnevenly;
  bool get isSharesEditable => isSplitByShares;
  bool get isPercentageEditable => isSplitByPercentage;

  @override
  void onInit() {
    super.onInit();
    amountString = Get.arguments ?? "";
    _addExpenseService = Get.put(AddExpenseService());
    userExpenseDataList = _addExpenseService.members
        .map((user) => UserExpenseData(user: user))
        .toList();

    // Add listeners to react to state changes
    ever(splitOption, (_) => _updateAmounts(recalculateDistribution: true));
    for (final data in userExpenseDataList) {
      ever(data.isSelected, (_) => _updateAmounts(recalculateDistribution: true));
      data.shareController.addListener(() => _updateAmounts());
    }
    // Set initial state
    _updateAmounts(recalculateDistribution: true);
  }

  void onPercentageChanged(UserExpenseData editingData) {
    _addExpenseService.redistributePercentages(
      userExpenseDataList: userExpenseDataList,
      editingUser: editingData,
    );
    _updateAmounts();
  }

  void onAmountChanged(UserExpenseData editingData) {
    _addExpenseService.redistributeAmounts(
      userExpenseDataList: userExpenseDataList,
      editingUser: editingData,
      totalAmount: _totalAmount,
    );
    _updateAmounts();
  }

  void onSendRequest() {
    String title = expenseTitleController.text.isEmpty
        ? Strings.expenseTitleDefaultText
        : expenseTitleController.text;
    _addExpenseService.updateUserAmountOwed(
        userExpenseDataList: userExpenseDataList);
    Get.back(
        result: Expense(title: title, amount: amountString, paidBy: "paidBy"));
  }

  void _updateAmounts({bool recalculateDistribution = false}) {
    _addExpenseService.updateAmounts(
      userExpenseDataList: userExpenseDataList,
      splitOption: splitOption.value,
      totalAmount: _totalAmount,
      recalculateDistribution: recalculateDistribution,
    );
    updateTrigger.value++;
  }

  @override
  void onClose() {
    expenseTitleController.dispose();
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
