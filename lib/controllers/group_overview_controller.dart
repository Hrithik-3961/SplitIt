import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/components/add_expense_dialog.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/pages/add_expense_page.dart';
import 'package:splitit/services/groups_overview_service.dart';

class GroupOverviewController extends GetxController {
  late GroupsOverviewService _groupsOverviewService;

  late RxList<User> members = <User>[].obs;
  late RxList<Expense> expenses = <Expense>[].obs;

  String get groupName => Get.arguments ?? "";

  get fabKey => _fabKey;

  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _fabKey = GlobalKey<ExpandableFabState>();

  @override
  void onInit() {
    super.onInit();
    int groupId = int.parse(Get.currentRoute.split('/').last);
    _groupsOverviewService = Get.put(GroupsOverviewService(groupId));
    members = _groupsOverviewService.groupDetails.members;
    expenses = _groupsOverviewService.groupDetails.expenses;
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
    final result = await Get.dialog(AddExpenseDialog(
      formKey: _formKey,
      textController: _textController,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          Get.back(result: _textController.text);
        }
      },
    ));

    final fabState = _fabKey.currentState;
    _groupsOverviewService.closeFAB(fabState);

    if (result != null) {
      final newExpense = await Get.toNamed(AddExpensePage.route, arguments: result);
      _groupsOverviewService.addExpense(newExpense);
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
