import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/components/add_expense_dialog.dart';
import 'package:splitit/components/add_member_dialog.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/pages/add_expense_page.dart';
import 'package:splitit/pages/record_payment_page.dart';
import 'package:splitit/pages/settle_up_page.dart';
import 'package:splitit/pages/transaction_details_page.dart';
import 'package:splitit/services/groups_overview_service.dart';

class GroupOverviewController extends GetxController {
  late GroupsOverviewService _groupsOverviewService;

  late GroupDetails groupDetails;
  late RxList<GroupMembers> members = <GroupMembers>[].obs;
  late RxList<MyTransaction> transactions = <MyTransaction>[].obs;

  late final String _groupName;
  String get groupName => _groupName;

  get fabKey => _fabKey;

  final _addMemberFormKey = GlobalKey<FormState>();
  final _addExpenseFormKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _fabKey = GlobalKey<ExpandableFabState>();

  @override
  void onInit() {
    super.onInit();
    _groupName = Get.arguments is String ? Get.arguments : "";
    String groupId = Get.currentRoute.split('/').last;
    _groupsOverviewService = Get.put(GroupsOverviewService(groupId));

    ever(_groupsOverviewService.groupDetailsRx, (group) {
      if (group != null) {
        groupDetails = group;
        members.assignAll(group.members);
        transactions.assignAll(group.transactions);
      }
    });
  }

  @override
  void onClose() {
    _textController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.onClose();
  }

  void handleAddMember(String item) {
    switch (item) {
      case Strings.addMember:
        Get.dialog(AddMemberDialog(
          formKey: _addMemberFormKey,
          inviteCode: groupDetails.inviteCode,
          nameController: _nameController,
          phoneController: _phoneController,
          onPressed: () async {
            if (_addMemberFormKey.currentState!.validate()) {
              try {
                await _groupsOverviewService.addMember(
                  name: _nameController.text,
                  phone: _phoneController.text,
                );
                _nameController.clear();
                _phoneController.clear();
                Get.back();
              } catch (e) {
                Get.snackbar(Strings.error, e.toString().replaceAll('Exception: ', ''));
              }
            }
          },
        ));
        break;
    }
  }

  void navigateToAddExpensePage() async {
    _textController.clear();
    final result = await Get.dialog(AddExpenseDialog(
      formKey: _addExpenseFormKey,
      textController: _textController,
      onPressed: () {
        if (_addExpenseFormKey.currentState!.validate()) {
          Get.back(result: _textController.text);
        }
      },
    ));

    final fabState = _fabKey.currentState;
    _groupsOverviewService.closeFAB(fabState);

    if (result != null) {
      final newTransaction = await Get.toNamed(AddExpensePage.route, arguments: result);
      _groupsOverviewService.addTransaction(newTransaction);
    }
  }

  void navigateToRecordPaymentPage() async {
    final newTransaction = await Get.toNamed(RecordPaymentPage.route);
    _groupsOverviewService.addTransaction(newTransaction);
  }

  void navigateToSettleUpPage() async {
    final newTransaction = await Get.toNamed(SettleUpPage.route);
    _groupsOverviewService.addTransaction(newTransaction);
  }

  void navigateToTransactionDetails(MyTransaction transaction) async {
    final updatedTransaction = await Get.toNamed(TransactionDetailsPage.route, arguments: {
      'transaction': transaction,
      'members': members,
    });
    
    if (updatedTransaction != null && updatedTransaction is MyTransaction) {
      _groupsOverviewService.addTransaction(updatedTransaction);
    }
  }
}

class GroupOverviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupOverviewController());
  }
}
