import 'package:get/get.dart';
import 'package:splitit/models/group_members.dart';

import '../controllers/group_overview_controller.dart';
import '../enums/transaction_type.dart';
import '../models/my_transaction.dart';
import '../utils/base_util.dart';

class RecordPaymentService {
  late final List<GroupMembers> _users;

  late final RxString paidFromMemberId;
  late final RxString paidToMemberId;

  final RxList<GroupMembers> paidFromUsers = <GroupMembers>[].obs;
  final RxList<GroupMembers> paidToUsers = <GroupMembers>[].obs;

  List<GroupMembers> get members => _users;

  RecordPaymentService() {
    _init();
  }

  void _init() {
    _users = Get.find<GroupOverviewController>().members;

    // Initialize with first two users, if available
    paidFromMemberId = (_users.isNotEmpty ? _users[0].memberId : '').obs;
    paidToMemberId = (_users.length > 1 ? _users[1].memberId : '').obs;

    // Set up listeners to update the lists reactively
    paidFromMemberId.listen((newFromId) => _updatePaidFromUsers(newFromId));
    paidToMemberId.listen((newToId) => _updatePaidToUsers(newToId));

    // Initial population of the lists (show all users)
    paidFromUsers.assignAll(_users);
    paidToUsers.assignAll(_users);
  }

  void _updatePaidFromUsers(newFromId) {
    if (newFromId == paidToMemberId.value) {
      paidToMemberId.value = _users.firstWhere((u) => u.memberId != newFromId).memberId;
    }
  }

  void _updatePaidToUsers(newToId) {
    if (newToId == paidFromMemberId.value) {
      paidFromMemberId.value = _users.firstWhere((u) => u.memberId != newToId).memberId;
    }
  }

  MyTransaction? savePayment({required String amountText}) {
    double amount = BaseUtil.getNumericValue(amountText) ?? 0;

    if (amount > 0) {
      GroupMembers paidFrom =
          _users.firstWhere((u) => u.memberId == paidFromMemberId.value);
      GroupMembers paidTo =
          _users.firstWhere((u) => u.memberId == paidToMemberId.value);
      paidFrom.addAmount(amount);
      paidTo.subtractAmount(amount);

      return MyTransaction(
          title: paidFrom.name,
          totalAmount: amountText,
          subtitle: paidTo.name,
          transactionType: TransactionType.payment,
          paidMap: {paidFrom.memberId: amount},
          owedMap: {paidTo.memberId: amount});
    }
    return null;
  }
}
