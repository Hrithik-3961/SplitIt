import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/utils/base_util.dart';
import 'package:splitit/enums/transaction_type.dart';

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

    if (_groupDetails.value != null) {
      _groupDetails.value!.members.add(newMember);
      _groupDetails.value = _groupDetails.value!
          .copyWith(memberCount: _groupDetails.value!.memberCount + 1);
    }
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
          final oldTransaction = _groupDetails.value?.transactions[index];
          _updateLocalBalances(transaction, oldTransaction: oldTransaction);
          _updateLocalTotalExpense(transaction, oldTransaction: oldTransaction);
          _groupDetails.value?.transactions[index] = transaction;
        }
      } else {
        // Add new transaction
        _updateLocalBalances(transaction);
        _updateLocalTotalExpense(transaction);
        _groupDetails.value?.transactions.insert(0, transaction);
      }
      _groupDetails.refresh();
      _firebaseService.addTransaction(
        groupId: _groupId,
        transaction: transaction,
      );
    }
  }

  void deleteTransaction(MyTransaction transaction) {
    if (transaction.id != null) {
      _updateLocalBalances(transaction, isDelete: true);
      _updateLocalTotalExpense(transaction, isDelete: true);
      _groupDetails.value?.transactions.removeWhere((t) => t.id == transaction.id);
      _groupDetails.refresh();
      _firebaseService.deleteTransaction(
        groupId: _groupId,
        transaction: transaction,
      );
    }
  }

  void _updateLocalTotalExpense(MyTransaction transaction,
      {bool isDelete = false, MyTransaction? oldTransaction}) {
    if (_groupDetails.value == null) return;

    double delta = 0;
    if (isDelete) {
      if (transaction.transactionType == TransactionType.expense) {
        delta = -(BaseUtil.getNumericValue(transaction.totalAmount) ?? 0);
      }
    } else if (oldTransaction != null) {
      double oldAmount = oldTransaction.transactionType == TransactionType.expense
          ? (BaseUtil.getNumericValue(oldTransaction.totalAmount) ?? 0)
          : 0;
      double newAmount = transaction.transactionType == TransactionType.expense
          ? (BaseUtil.getNumericValue(transaction.totalAmount) ?? 0)
          : 0;
      delta = newAmount - oldAmount;
    } else {
      if (transaction.transactionType == TransactionType.expense) {
        delta = BaseUtil.getNumericValue(transaction.totalAmount) ?? 0;
      }
    }

    if (delta != 0) {
      _groupDetails.value = _groupDetails.value!.copyWith(
          totalExpense: _groupDetails.value!.totalExpense + delta);
    }
  }

  void _updateLocalBalances(MyTransaction transaction,
      {bool isDelete = false, MyTransaction? oldTransaction}) {
    if (_groupDetails.value == null) return;

    final allMemberIds = {
      ...transaction.paidMap.keys,
      ...transaction.owedMap.keys,
      if (oldTransaction != null) ...oldTransaction.paidMap.keys,
      if (oldTransaction != null) ...oldTransaction.owedMap.keys,
    };

    for (final memberId in allMemberIds) {
      final member = _groupDetails.value!.members
          .firstWhereOrNull((m) => m.memberId == memberId);
      if (member == null) continue;

      if (isDelete) {
        final paid = transaction.paidMap[memberId] ?? 0;
        final owed = transaction.owedMap[memberId] ?? 0;
        member.subtractAmount(paid - owed);
      } else if (oldTransaction != null) {
        final oldPaid = oldTransaction.paidMap[memberId] ?? 0;
        final oldOwed = oldTransaction.owedMap[memberId] ?? 0;
        final newPaid = transaction.paidMap[memberId] ?? 0;
        final newOwed = transaction.owedMap[memberId] ?? 0;
        member.addAmount((newPaid - newOwed) - (oldPaid - oldOwed));
      } else {
        final paid = transaction.paidMap[memberId] ?? 0;
        final owed = transaction.owedMap[memberId] ?? 0;
        member.addAmount(paid - owed);
      }
    }
  }
}
