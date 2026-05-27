import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/models/group_details.dart';

import 'firebase_service.dart';

class GroupsOverviewService {
  late final String _groupId;
  late final FirebaseService _firebaseService;
  final Rxn<GroupDetails> _groupDetails = Rxn<GroupDetails>();

  Rxn<GroupDetails> get groupDetailsRx => _groupDetails;

  GroupsOverviewService(String groupId) {
    _groupId = groupId;
    _init(groupId);
  }

  Future<void> _init(String groupId) async {
    _firebaseService = Get.find<FirebaseService>();

    final groupFuture =
    _firebaseService.groupsRef.doc(groupId).get();

    final membersFuture = _firebaseService.groupMembersRef
        .where('groupId', isEqualTo: groupId)
        .get();

    final transactionsFuture = _firebaseService.transactionsRef
        .where('groupId', isEqualTo: groupId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    final results = await Future.wait([
      groupFuture,
      membersFuture,
      transactionsFuture,
    ]);

    final groupSnap = results[0] as DocumentSnapshot<GroupDetails>;
    final membersSnap = results[1] as QuerySnapshot<GroupMembers>;
    final transactionsSnap = results[2] as QuerySnapshot<MyTransaction>;

    final group = groupSnap.data();
    final members = membersSnap.docs.map((doc) => doc.data()).toList();
    final transactions = transactionsSnap.docs.map((doc) => doc.data()).toList();

    group?.members.addAll(members);
    group?.transactions.addAll(transactions);
    _groupDetails.value = group;
  }

  Future<void> addMember({required String phone, required String name}) async {
    final newMember = await _firebaseService.addMemberByPhone(
        groupId: _groupId,
        phone: '${Strings.phoneNumberPrefix.trim()}${phone.trim()}',
        name: name);

    _groupDetails.value?.members.add(newMember);
    _groupDetails.refresh();
  }

  void closeFAB(ExpandableFabState? fabState) {
    if (fabState != null && fabState.isOpen) {
      fabState.toggle();
    }
  }

  void addTransaction(MyTransaction? transaction) {
    if (transaction != null) {
      if (transaction.id != null) {
        // Update existing transaction in the list
        final index = _groupDetails.value?.transactions
            .indexWhere((t) => t.id == transaction.id);
        if (index != null && index != -1) {
          _groupDetails.value?.transactions[index] = transaction;
        }
      } else {
        // Add new transaction
        _groupDetails.value?.transactions.insert(0, transaction);
      }
      _groupDetails.refresh();
      _firebaseService.addTransaction(
        groupId: _groupId,
        transaction: transaction,
      );
    }
  }
}
