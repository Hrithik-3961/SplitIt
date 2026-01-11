import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/add_expense_dialog.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/pages/add_expense_page.dart';
import 'package:splitit/services/groups_overview_service.dart';

class GroupOverviewController extends GetxController {
  late GroupsOverviewService _groupsOverviewService;

  List<User> get members => _groupsOverviewService.groupDetails.members;

  List<Expense> get expenses => _groupsOverviewService.groupDetails.expenses;

  String get groupName => Get.arguments ?? "";

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    int groupId = int.parse(Get.currentRoute.split('/').last);
    _groupsOverviewService = Get.put(GroupsOverviewService(groupId));
  }

  @override
  void onClose() {
    _textController.dispose();
    super.onClose();
  }

  void handleAddMember(String item) {
    switch (item) {
      case Strings.addMember:
        _groupsOverviewService.addMember();
        break;
    }
  }

  void navigateToAddExpensePage() async {
    _textController.clear();
    final amount = await Get.dialog(
      AddExpenseDialog(
        formKey: _formKey,
        textController: _textController,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Get.back(result: _textController.text);
          }
        },
      ),
    );

    if (amount != null) {
      final expense = await Get.toNamed(AddExpensePage.route, arguments: amount);
      if (expense != null) {
        _groupsOverviewService.addExpense(expense);
      }
    }
  }

  void handleRecordPayment() {}
}

class GroupOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupOverviewController());
  }
}
