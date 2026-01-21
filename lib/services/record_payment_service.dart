import 'package:get/get.dart';

import '../controllers/group_overview_controller.dart';
import '../models/user.dart';
import '../models/transaction.dart';
import '../utils/base_util.dart';

class RecordPaymentService {
  late final List<User> _users;

  late final RxString paidFromUserId;
  late final RxString paidToUserId;

  final RxList<User> paidFromUsers = <User>[].obs;
  final RxList<User> paidToUsers = <User>[].obs;

  List<User> get members => _users;

  RecordPaymentService() {
    _init();
  }

  void _init() {
    _users = Get.find<GroupOverviewController>().members;

    // Initialize with first two users, if available
    paidFromUserId = (_users.isNotEmpty ? _users[0].id : '').obs;
    paidToUserId = (_users.length > 1 ? _users[1].id : '').obs;

    // Set up listeners to update the lists reactively
    paidFromUserId.listen((_) => _updatePaidToUsers());
    paidToUserId.listen((_) => _updatePaidFromUsers());

    // Initial population of the lists
    _updatePaidFromUsers();
    _updatePaidToUsers();
  }

  void _updatePaidFromUsers() {
    final newUsers = _users.where((u) => u.id != paidToUserId.value).toList();
    paidFromUsers.assignAll(newUsers);
    if (!paidFromUsers.any((u) => u.id == paidFromUserId.value) &&
        paidFromUsers.isNotEmpty) {
      paidFromUserId.value = paidFromUsers[0].id;
    }
  }

  void _updatePaidToUsers() {
    final newUsers = _users.where((u) => u.id != paidFromUserId.value).toList();
    paidToUsers.assignAll(newUsers);
    if (!paidToUsers.any((u) => u.id == paidToUserId.value) &&
        paidToUsers.isNotEmpty) {
      paidToUserId.value = paidToUsers[0].id;
    }
  }

  Transaction? savePayment({required String amountText}) {
    double amount = BaseUtil.getNumericValue(amountText) ?? 0;

    if (amount > 0) {
      User paidFrom = _users.firstWhere((u) => u.id == paidFromUserId.value);
      User paidTo = _users.firstWhere((u) => u.id == paidToUserId.value);
      paidFrom.addAmount(amount);
      paidTo.subtractAmount(amount);

      return Transaction(
          title: paidFrom.name,
          amount: amountText,
          subtitle: paidTo.name,
          type: TransactionType.payment);
    }
    return null;
  }
}
