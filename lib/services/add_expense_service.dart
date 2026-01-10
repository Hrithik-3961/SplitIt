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

  void updateAmounts({
    required List<UserExpenseData> userExpenseDataList,
    required String splitOption,
    required double totalAmount,
    bool recalculateDistribution = false,
  }) {
    final isSplitEvenly = splitOption == Strings.splitOptions[0];
    final isSplitByShares = splitOption == Strings.splitOptions[1];
    final isSplitByPercentage = splitOption == Strings.splitOptions[2];

    if (isSplitEvenly) {
      final selectedUsers =
          userExpenseDataList.where((d) => d.isSelected.value).toList();
      if (selectedUsers.isEmpty) {
        for (final data in userExpenseDataList) {
          data.amountController.clear();
        }
        return;
      }
      final splitAmount = totalAmount / selectedUsers.length;

      for (final data in userExpenseDataList) {
        if (data.isSelected.value) {
          data.amountController.text = BaseUtil.getFormattedCurrency(splitAmount.toString());
        } else {
          data.amountController.clear();
        }
      }
    } else if (isSplitByShares) {
        final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
        if (selectedUsers.isEmpty) {
            for (final data in userExpenseDataList) {
                data.amountController.clear();
            }
            return;
        }

        double totalShares = 0;
        for (final data in selectedUsers) {
            totalShares += double.tryParse(data.shareController.text) ?? 0;
        }

        if (totalShares == 0) {
            for (final data in userExpenseDataList) {
                if (data.isSelected.value) {
                    data.amountController.text = BaseUtil.getFormattedCurrency("0");
                } else {
                    data.amountController.clear();
                }
            }
            return;
        }

        final amountPerShare = totalAmount / totalShares;

        for (final data in userExpenseDataList) {
            if (data.isSelected.value) {
                final userShares = double.tryParse(data.shareController.text) ?? 0;
                final userAmount = userShares * amountPerShare;
                data.amountController.text = BaseUtil.getFormattedCurrency(userAmount.toString());
            } else {
                data.amountController.clear();
            }
        }
    } else if (isSplitByPercentage) {
        final selectedUsers = userExpenseDataList.where((d) => d.isSelected.value).toList();
        if (selectedUsers.isEmpty) {
            for (final data in userExpenseDataList) {
                data.amountController.clear();
            }
            return;
        }

        if (recalculateDistribution) {
          final evenPercentage = 100 / selectedUsers.length;
          for (final data in userExpenseDataList) {
            if (data.isSelected.value) {
              data.percentageController.text = evenPercentage.toStringAsFixed(2);
            } else {
              data.percentageController.clear();
            }
          }
        }

        for (final data in userExpenseDataList) {
            if (data.isSelected.value) {
                final userPercentage = double.tryParse(data.percentageController.text) ?? 0;
                final userAmount = (totalAmount * userPercentage) / 100;
                data.amountController.text = BaseUtil.getFormattedCurrency(userAmount.toString());
            } else {
                data.amountController.clear();
            }
        }
    } else {
      // If not splitting by another method, clear the fields for manual entry
      for (final data in userExpenseDataList) {
        if (data.isSelected.value) {
          data.amountController.clear();
        }
      }
    }
  }
}
