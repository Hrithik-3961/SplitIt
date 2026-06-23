import 'package:get/get.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/pages/add_expense_page.dart';
import 'package:splitit/pages/record_payment_page.dart';
import 'package:splitit/services/groups_overview_service.dart';
import 'package:splitit/services/transaction_details_service.dart';
import 'package:splitit/constants/strings.dart';
import 'package:flutter/material.dart';
import '../enums/transaction_type.dart';

class TransactionDetailsController extends GetxController {
  late Rx<MyTransaction> transaction;
  late final TransactionDetailsService _transactionDetailsService;
  late final GroupsOverviewService _groupsOverviewService;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    transaction = (args['transaction'] as MyTransaction).obs;
    final members = args['members'] as List<GroupMembers>;
    _transactionDetailsService = TransactionDetailsService(members: members);
    _groupsOverviewService = Get.find<GroupsOverviewService>();
  }

  String getMemberName(String memberId) =>
      _transactionDetailsService.getMemberName(memberId);

  void onEditClicked() async {
    dynamic result;
    if (transaction.value.transactionType == TransactionType.expense) {
      result = await Get.toNamed(AddExpensePage.route, arguments: transaction.value);
    } else {
      result = await Get.toNamed(RecordPaymentPage.route, arguments: transaction.value);
    }

    if (result != null && result is MyTransaction) {
      transaction.value = result;
    }
  }

  void onDeleteClicked() {
    Get.dialog(
      AlertDialog(
        title: const Text(Strings.deleteTransaction),
        content: const Text(Strings.deleteConfirmMsg),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(Strings.cancel),
          ),
          TextButton(
            onPressed: () {
              _groupsOverviewService.deleteTransaction(transaction.value);
              Get.back(); // Close dialog
              Get.back(result: null); // Go back to Overview with 'null' to indicate deletion
            },
            child: const Text(Strings.delete, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void onBack() {
    Get.back(result: transaction.value);
  }
}

class TransactionDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionDetailsController());
  }
}
