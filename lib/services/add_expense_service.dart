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

  void updateAmounts({
    required List<UserExpenseData> userExpenseDataList,
    required String splitOption,
    required double totalAmount,
  }) {
    final isSplitEvenly = splitOption == Strings.splitOptions[0];
    if (isSplitEvenly) {
      final selectedUsers =
          userExpenseDataList.where((d) => d.isSelected.value).toList();
      if (selectedUsers.isEmpty) {
        for (final data in userExpenseDataList) {
          data.controller.clear();
        }
        return;
      }
      final splitAmount = totalAmount / selectedUsers.length;

      for (final data in userExpenseDataList) {
        if (data.isSelected.value) {

          data.controller.text = BaseUtil.getFormattedCurrency(splitAmount.toString());
        } else {
          data.controller.clear();
        }
      }
    } else {
      // If not splitting evenly, clear the fields for manual entry
      for (final data in userExpenseDataList) {
        if (data.isSelected.value) {
          data.controller.clear();
        }
      }
    }
  }
}
