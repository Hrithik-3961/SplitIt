import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/paid_by_bottom_sheet.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/add_expense_service.dart';
import 'package:splitit/utils/base_util.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/utils/expense_validator.dart';

class UserExpenseData {
  final User user;
  final TextEditingController splitAmountController = TextEditingController();
  final TextEditingController shareController =
      TextEditingController(text: '1');
  final TextEditingController percentageController = TextEditingController();
  final TextEditingController paidByController = TextEditingController();
  final FocusNode amountFocusNode = FocusNode();
  final FocusNode shareFocusNode = FocusNode();
  final FocusNode percentageFocusNode = FocusNode();
  final RxBool isPaidForSelected = true.obs;
  final RxBool isPaidBySelected = false.obs;
  bool isAmountManuallyEdited = false;
  bool isPaidByManuallyEdited = false;
  bool isPercentageManuallyEdited = false;

  UserExpenseData({required this.user});

  void dispose() {
    splitAmountController.dispose();
    shareController.dispose();
    percentageController.dispose();
    paidByController.dispose();
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
  final RxString paidByText = ''.obs;

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
      ever(data.isPaidForSelected,
          (_) => _updateAmounts(recalculateDistribution: true));
      data.shareController.addListener(() => _updateAmounts());
      // Listen for changes in who paid
      ever(data.isPaidBySelected, (_) => _distributePaidByAmounts());
    }
    // Set initial state
    _updateAmounts(recalculateDistribution: true);

    // Set initial paid by state
    if (userExpenseDataList.isNotEmpty) {
      userExpenseDataList.first.isPaidBySelected.value = true;
    }
  }

  void onPaidByClicked() {
    Get.bottomSheet(
      PaidByBottomSheet(
        userExpenseDataList: userExpenseDataList,
        totalAmount: _totalAmount,
      ),
    );
  }

  // Called when the user manually edits a paid by amount
  void onPaidByAmountChanged(UserExpenseData editingUser, bool isManuallyEdited) {
    if (isManuallyEdited) {
      editingUser.isPaidByManuallyEdited = true;
    }
    _distributePaidByAmounts();
  }

  void onPercentageChanged(UserExpenseData editingData) {
    editingData.isPercentageManuallyEdited = true;
    _addExpenseService.redistributePercentages(
      userExpenseDataList: userExpenseDataList,
      editingUser: editingData,
    );
    _updateAmounts();
  }

  void onAmountChanged(UserExpenseData editingData) {
    if (isSplitUnevenly) {
      editingData.isAmountManuallyEdited = true;
    }
    _addExpenseService.redistributeAmounts(
      userExpenseDataList: userExpenseDataList,
      editingUser: editingData,
      totalAmount: _totalAmount,
    );
    _updateAmounts();
  }

  void onSendRequest() {
    double totalSplitAmount = 0;
    double totalPaidByAmount = 0;
    for (var u in userExpenseDataList) {
      final amounts = BaseUtil.getUserAmounts(u);
      totalSplitAmount += amounts.splitAmount;
      totalPaidByAmount += amounts.paidAmount;
    }

    String? message = ExpenseValidator.validateSplit(totalPaidByAmount, _totalAmount, totalSplitAmount);
    if (message != null) {
      _showSnackBar(message);
      return;
    }

    String title = expenseTitleController.text.isEmpty
        ? Strings.expenseTitleDefaultText
        : expenseTitleController.text;
    _addExpenseService.updateUserAmountOwed(
        userExpenseDataList: userExpenseDataList);
    Get.back(
        result: Expense(title: title, amount: amountString, paidBy: paidByText.value));
  }

  void _showSnackBar(String message) {
    Get.rawSnackbar(
        message: message, margin: Values.defaultMargin);
  }

  void _updateAmounts({bool recalculateDistribution = false}) {
    if (recalculateDistribution) {
      for (final data in userExpenseDataList) {
        data.isAmountManuallyEdited = false;
        data.isPercentageManuallyEdited = false;
      }
    }
    _addExpenseService.updateAmounts(
      userExpenseDataList: userExpenseDataList,
      splitOption: splitOption.value,
      totalAmount: _totalAmount,
      recalculateDistribution: recalculateDistribution,
    );
    updateTrigger.value++;
  }

  void _distributePaidByAmounts() {
    _addExpenseService.distributePaidByAmounts(
      userExpenseDataList: userExpenseDataList,
      totalAmount: _totalAmount,
      paidByText: paidByText,
    );
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
