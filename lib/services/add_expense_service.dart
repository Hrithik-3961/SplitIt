import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/add_expense_controller.dart';
import 'package:splitit/controllers/group_overview_controller.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/utils/base_util.dart';

class AddExpenseService {
  late List<User> _members;

  List<User> get members => _members;
  List<String> get splitOptions => Strings.splitOptions;

  AddExpenseService() {
    _init();
  }

  void _init() {
    _members = Get.find<GroupOverviewController>().members;
  }

  void redistributePercentages({
    required List<UserExpenseData> userExpenseDataList,
    required UserExpenseData editingUser,
  }) {
    final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
    final otherUsers = selectedUsers.where((u) => u != editingUser).toList();

    if (otherUsers.isEmpty) return;

    final editingUserPercentage = double.tryParse(editingUser.percentageController.text) ?? 0;
    final remainingPercentage = 100 - editingUserPercentage;

    if (remainingPercentage < 0) {
      editingUser.percentageController.text = "100.00";
      for (final other in otherUsers) {
        other.percentageController.text = "0.00";
      }
      return;
    }

    final splitPercentage = remainingPercentage / otherUsers.length;

    for (final other in otherUsers) {
      other.percentageController.text = splitPercentage.toStringAsFixed(2);
    }
  }

  void redistributeAmounts({
    required List<UserExpenseData> userExpenseDataList,
    required UserExpenseData editingUser,
    required double totalAmount,
  }) {
    final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
    final otherUsers = selectedUsers.where((u) => u != editingUser).toList();

    if (otherUsers.isEmpty) return;

    final editingUserAmount = BaseUtil.getNumericValue(editingUser.amountController.text) ?? 0;
    final remainingAmount = totalAmount - editingUserAmount;

    if (remainingAmount < 0) {
      editingUser.amountController.text = BaseUtil.getFormattedCurrency(totalAmount.toString());
      for (final other in otherUsers) {
        other.amountController.text = BaseUtil.getFormattedCurrency("0");
      }
      return;
    }

    final splitAmount = remainingAmount / otherUsers.length;

    for (final other in otherUsers) {
      other.amountController.text = BaseUtil.getFormattedCurrency(splitAmount.toString());
    }
  }

  void updateAmounts({
    required List<UserExpenseData> userExpenseDataList,
    required String splitOption,
    required double totalAmount,
    bool recalculateDistribution = false,
  }) {
    if (splitOption == Strings.splitOptions[0]) {
      _splitEvenly(userExpenseDataList, totalAmount);
    } else if (splitOption == Strings.splitOptions[1]) {
      _splitByShares(userExpenseDataList, totalAmount);
    } else if (splitOption == Strings.splitOptions[2]) {
      _splitByPercentage(userExpenseDataList, totalAmount, recalculateDistribution);
    } else if (splitOption == Strings.splitOptions[3]) {
      _splitUnevenly(userExpenseDataList, totalAmount, recalculateDistribution);
    } else {
      _clearAllAmounts(userExpenseDataList);
    }
  }

  void updateUserAmountOwed(
      {required List<UserExpenseData> userExpenseDataList}) {
    for (var data in userExpenseDataList) {
      final amount = BaseUtil.getNumericValue(data.amountController.text);
      if (amount != null) {
        data.user.addExpense(amount);
      }
    }
  }

  void _splitEvenly(List<UserExpenseData> userExpenseDataList, double totalAmount) {
    final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
    if (selectedUsers.isEmpty) {
      _clearAllAmounts(userExpenseDataList);
      return;
    }
    final splitAmount = totalAmount / selectedUsers.length;
    for (final data in userExpenseDataList) {
      data.amountController.text = data.isSelected.value
          ? BaseUtil.getFormattedCurrency(splitAmount.toString())
          : '';
    }
  }

  void _splitByShares(List<UserExpenseData> userExpenseDataList, double totalAmount) {
    final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
    if (selectedUsers.isEmpty) {
      _clearAllAmounts(userExpenseDataList);
      return;
    }

    double totalShares = 0;
    for (final data in selectedUsers) {
      totalShares += double.tryParse(data.shareController.text) ?? 0;
    }

    if (totalShares == 0) {
      for (final data in userExpenseDataList) {
        data.amountController.text = data.isSelected.value ? BaseUtil.getFormattedCurrency("0") : '';
      }
      return;
    }

    final amountPerShare = totalAmount / totalShares;
    for (final data in userExpenseDataList) {
      if (data.isSelected.value) {
        final userShares = double.tryParse(data.shareController.text) ?? 0;
        data.amountController.text = BaseUtil.getFormattedCurrency((userShares * amountPerShare).toString());
      } else {
        data.amountController.clear();
      }
    }
  }

  void _splitByPercentage(
      List<UserExpenseData> userExpenseDataList, double totalAmount, bool recalculateDistribution) {
    final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
    if (selectedUsers.isEmpty) {
      _clearAllAmounts(userExpenseDataList);
      return;
    }

    if (recalculateDistribution) {
      final evenPercentage = 100 / selectedUsers.length;
      for (final data in userExpenseDataList) {
        data.percentageController.text = data.isSelected.value ? evenPercentage.toStringAsFixed(2) : '';
      }
    }

    for (final data in userExpenseDataList) {
      if (data.isSelected.value) {
        final userPercentage = double.tryParse(data.percentageController.text) ?? 0;
        data.amountController.text = BaseUtil.getFormattedCurrency(((totalAmount * userPercentage) / 100).toString());
      } else {
        data.amountController.clear();
      }
    }
  }

  void _splitUnevenly(List<UserExpenseData> userExpenseDataList, double totalAmount, bool recalculateDistribution) {
    if (recalculateDistribution) {
      _splitEvenly(userExpenseDataList, totalAmount);
    }
  }

  void _clearAllAmounts(List<UserExpenseData> userExpenseDataList) {
    for (final data in userExpenseDataList) {
      data.amountController.clear();
    }
  }
}
