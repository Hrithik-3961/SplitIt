import 'package:get/get.dart';
import 'package:splitit/models/group_members.dart';

import '../controllers/group_overview_controller.dart';
import '../enums/transaction_type.dart';
import '../models/my_transaction.dart';
import '../utils/base_util.dart';

class RecordPaymentService {
  late final List<GroupMembers> _users;

  late final RxString paidFromUserId;
  late final RxString paidToUserId;

  final RxList<GroupMembers> paidFromUsers = <GroupMembers>[].obs;
  final RxList<GroupMembers> paidToUsers = <GroupMembers>[].obs;

  List<GroupMembers> get members => _users;

  RecordPaymentService() {
    _init();
  }

  void _init() {
    _users = Get.find<GroupOverviewController>().members;

    // Initialize with first two users, if available
    paidFromUserId = (_users.isNotEmpty ? _users[0].uid : '').obs;
    paidToUserId = (_users.length > 1 ? _users[1].uid : '').obs;

    // Set up listeners to update the lists reactively
    paidFromUserId.listen((_) => _updatePaidToUsers());
    paidToUserId.listen((_) => _updatePaidFromUsers());

    // Initial population of the lists
    _updatePaidFromUsers();
    _updatePaidToUsers();
  }

  void _updatePaidFromUsers() {
    final newUsers = _users.where((u) => u.uid != paidToUserId.value).toList();
    paidFromUsers.assignAll(newUsers);
    if (!paidFromUsers.any((u) => u.uid == paidFromUserId.value) &&
        paidFromUsers.isNotEmpty) {
      paidFromUserId.value = paidFromUsers[0].uid;
    }
  }

  void _updatePaidToUsers() {
    final newUsers =
        _users.where((u) => u.uid != paidFromUserId.value).toList();
    paidToUsers.assignAll(newUsers);
    if (!paidToUsers.any((u) => u.uid == paidToUserId.value) &&
        paidToUsers.isNotEmpty) {
      paidToUserId.value = paidToUsers[0].uid;
    }
  }

  MyTransaction? savePayment({required String amountText}) {
    double amount = BaseUtil.getNumericValue(amountText) ?? 0;

    if (amount > 0) {
      GroupMembers paidFrom = _users.firstWhere((u) => u.uid == paidFromUserId.value);
      GroupMembers paidTo = _users.firstWhere((u) => u.uid == paidToUserId.value);
      paidFrom.addAmount(amount);
      paidTo.subtractAmount(amount);

      return MyTransaction(
          title: paidFrom.name,
          totalAmount: amountText,
          subtitle: paidTo.name,
          transactionType: TransactionType.payment,
          paidMap: {paidFrom.uid: amount},
          owedMap: {paidTo.uid: amount});
    }
    return null;
  }
}
