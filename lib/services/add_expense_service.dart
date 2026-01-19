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
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidForSelected.value).toList();

    final manuallyEditedUsers = selectedUsers
        .where((u) => u.isPercentageManuallyEdited && u != editingUser)
        .toList();
    final manuallyEditedPercentage = manuallyEditedUsers.fold<double>(
        0,
        (prev, u) =>
            prev + (double.tryParse(u.percentageController.text) ?? 0));

    final otherUsers = selectedUsers
        .where((u) => !u.isPercentageManuallyEdited && u != editingUser)
        .toList();

    if (otherUsers.isEmpty) return;

    final editingUserPercentage =
        double.tryParse(editingUser.percentageController.text) ?? 0;
    final remainingPercentage = 100 - editingUserPercentage - manuallyEditedPercentage;

    if (remainingPercentage < 0) {
      editingUser.percentageController.text = (100 - manuallyEditedPercentage).toStringAsFixed(2);
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
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidForSelected.value).toList();

    final manuallyEditedUsers = selectedUsers
        .where((u) => u.isAmountManuallyEdited && u != editingUser)
        .toList();
    final manuallyEditedAmount = manuallyEditedUsers.fold<double>(
        0,
        (prev, u) => prev + BaseUtil.getUserAmounts(u).splitAmount);

    final otherUsers = selectedUsers
        .where((u) => !u.isAmountManuallyEdited && u != editingUser)
        .toList();

    if (otherUsers.isEmpty) return;

    final editingUserAmount = BaseUtil.getUserAmounts(editingUser).splitAmount;
    final remainingAmount = totalAmount - editingUserAmount - manuallyEditedAmount;

    if (remainingAmount < 0) {
      editingUser.splitAmountController.text =
          BaseUtil.getFormattedCurrency((totalAmount - manuallyEditedAmount).toString());
      for (final other in otherUsers) {
        other.splitAmountController.text = BaseUtil.getFormattedCurrency("0");
      }
      return;
    }

    final splitAmount = remainingAmount / otherUsers.length;

    for (final other in otherUsers) {
      other.splitAmountController.text =
          BaseUtil.getFormattedCurrency(splitAmount.toString());
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
      _splitByPercentage(
          userExpenseDataList, totalAmount, recalculateDistribution);
    } else if (splitOption == Strings.splitOptions[3]) {
      _splitUnevenly(userExpenseDataList, totalAmount, recalculateDistribution);
    } else {
      _clearAllAmounts(userExpenseDataList);
    }
  }

  void updateUserAmountOwed(
      {required List<UserExpenseData> userExpenseDataList}) {
    for (var data in userExpenseDataList) {
      final amounts = BaseUtil.getUserAmounts(data);
      data.user.addExpense(amounts.splitAmount);
      data.user.addPayment(amounts.paidAmount);
    }
  }

 void distributePaidByAmounts({
    required List<UserExpenseData> userExpenseDataList,
    required double totalAmount,
    required RxString paidByText,
  }) {
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidBySelected.value).toList();
    paidByText.value = _getPaidByText(selectedUsers);

    for (var user in userExpenseDataList.where((d) => !d.isPaidBySelected.value)) {
      user.paidByController.clear();
      user.isPaidByManuallyEdited = false;
    }

    if (selectedUsers.isEmpty) {
      return;
    }

    final manuallyEditedUsers =
        selectedUsers.where((u) => u.isPaidByManuallyEdited).toList();
    final manuallyEditedAmount = manuallyEditedUsers.fold<double>(
        0,
        (prev, u) => prev + BaseUtil.getUserAmounts(u).paidAmount);

    final nonManuallyEditedUsers =
        selectedUsers.where((u) => !u.isPaidByManuallyEdited).toList();

    if (nonManuallyEditedUsers.isEmpty) {
      return;
    }

    final remainingAmount = totalAmount - manuallyEditedAmount;

    if (nonManuallyEditedUsers.length == 1) {
      final lastUser = nonManuallyEditedUsers.first;
      lastUser.paidByController.text =
          BaseUtil.getFormattedCurrency(remainingAmount.toString());
    } else {
      final splitAmount = remainingAmount > 0
          ? remainingAmount / nonManuallyEditedUsers.length
          : 0;

      for (int i = 0; i < nonManuallyEditedUsers.length - 1; i++) {
        final user = nonManuallyEditedUsers[i];
        user.paidByController.text =
            BaseUtil.getFormattedCurrency(splitAmount.toString());
      }

      final lastUser = nonManuallyEditedUsers.last;
      final amountForLastUser = totalAmount -
          manuallyEditedAmount -
          (splitAmount * (nonManuallyEditedUsers.length - 1));
      lastUser.paidByController.text =
          BaseUtil.getFormattedCurrency(amountForLastUser.toString());
    }
  }

  String _getPaidByText(List<UserExpenseData> selectedUsers) {
    if (selectedUsers.isEmpty) {
      return '';
    }
    if (selectedUsers.length == 1) {
      return selectedUsers.first.user.name;
    }
    return "${selectedUsers.length} people";
  }

  void _splitEvenly(
      List<UserExpenseData> userExpenseDataList, double totalAmount) {
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidForSelected.value).toList();
    if (selectedUsers.isEmpty) {
      _clearAllAmounts(userExpenseDataList);
      return;
    }
    final splitAmount = totalAmount / selectedUsers.length;
    for (final data in userExpenseDataList) {
      data.splitAmountController.text = data.isPaidForSelected.value
          ? BaseUtil.getFormattedCurrency(splitAmount.toString())
          : '';
    }
  }

  void _splitByShares(
      List<UserExpenseData> userExpenseDataList, double totalAmount) {
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidForSelected.value).toList();
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
        data.splitAmountController.text = data.isPaidForSelected.value
            ? BaseUtil.getFormattedCurrency("0")
            : '';
      }
      return;
    }

    final amountPerShare = totalAmount / totalShares;
    for (final data in userExpenseDataList) {
      if (data.isPaidForSelected.value) {
        final userShares = double.tryParse(data.shareController.text) ?? 0;
        data.splitAmountController.text = BaseUtil.getFormattedCurrency(
            (userShares * amountPerShare).toString());
      } else {
        data.splitAmountController.clear();
      }
    }
  }

  void _splitByPercentage(List<UserExpenseData> userExpenseDataList,
      double totalAmount, bool recalculateDistribution) {
    final selectedUsers =
        userExpenseDataList.where((d) => d.isPaidForSelected.value).toList();
    if (selectedUsers.isEmpty) {
      _clearAllAmounts(userExpenseDataList);
      return;
    }

    if (recalculateDistribution) {
      final nonManuallyEditedUsers = selectedUsers.where((u) => !u.isPercentageManuallyEdited).toList();
      final manuallyEditedPercentage = selectedUsers
          .where((u) => u.isPercentageManuallyEdited)
          .fold<double>(0, (prev, u) => prev + (double.tryParse(u.percentageController.text) ?? 0));

      final remainingPercentage = 100 - manuallyEditedPercentage;

      if(nonManuallyEditedUsers.isNotEmpty) {
        final evenPercentage = remainingPercentage / nonManuallyEditedUsers.length;
        for (final data in nonManuallyEditedUsers) {
          data.percentageController.text = data.isPaidForSelected.value
              ? evenPercentage.toStringAsFixed(2)
              : '';
        }
      }
    }

    for (final data in userExpenseDataList) {
      if (data.isPaidForSelected.value) {
        final userPercentage =
            double.tryParse(data.percentageController.text) ?? 0;
        data.splitAmountController.text = BaseUtil.getFormattedCurrency(
            ((totalAmount * userPercentage) / 100).toString());
      } else {
        data.splitAmountController.clear();
      }
    }
  }

  void _splitUnevenly(List<UserExpenseData> userExpenseDataList,
      double totalAmount, bool recalculateDistribution) {
    if (recalculateDistribution) {
      _splitEvenly(userExpenseDataList, totalAmount);
    }
  }

  void _clearAllAmounts(List<UserExpenseData> userExpenseDataList) {
    for (final data in userExpenseDataList) {
      data.splitAmountController.clear();
    }
  }
}
