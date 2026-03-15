import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/models/transaction.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/my_user.dart';

import 'firebase_service.dart';

class GroupsOverviewService {
  late final String _groupId;
  late final FirebaseService _firebaseService;
  final Rxn<GroupDetails> _groupDetails = Rxn<GroupDetails>();

  Rxn<GroupDetails> get groupDetailsRx => _groupDetails;

  GroupsOverviewService(String groupId, String groupName) {
    _groupId = groupId;
    _init(groupId, groupName);
  }

  Future<void> _init(String groupId, String groupName) async {
    _firebaseService = Get.find<FirebaseService>();

    final membersFuture = _firebaseService.groupMembersRef
        .where('groupId', isEqualTo: groupId)
        .get();

    final expensesFuture = _firebaseService.expensesRef
        .where('groupId', isEqualTo: groupId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    final results = await Future.wait([
      membersFuture,
      expensesFuture,
    ]);
    final membersSnap = results[0];
    final expensesSnap = results[1];

    final members = membersSnap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return MyUser.fromJson(data);
    }).toList();
    final expenses = expensesSnap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return MyTransaction.fromJson(data);
    }).toList();

    _groupDetails.value = GroupDetails(id: groupId, title: groupName, members: members.obs, transactions: expenses.obs);
  }

  void addMember() {
    _groupDetails.value?.members
        .add(MyUser(name: "New Memberrrrrrrr", uid: '5', isGuest: true));
  }

  void closeFAB(ExpandableFabState? fabState) {
    if (fabState != null && fabState.isOpen) {
      fabState.toggle();
    }
  }

  void addTransaction(MyTransaction? transaction) {
    if (transaction != null) {
      _groupDetails.value?.transactions.insert(0, transaction);
      _groupDetails.refresh();
      _firebaseService.addTransaction(
          groupId: _groupId,
        transaction: transaction,
      );
    }
  }
}
