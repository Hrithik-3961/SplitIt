import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/all_groups_controller.dart';
import 'package:splitit/enums/transaction_type.dart';
import 'package:splitit/models/cross_group_suggestion.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/services/firebase_service.dart';
import 'package:splitit/utils/base_util.dart';
import 'package:splitit/utils/debt_simplifier.dart';

import '../models/suggested_payment.dart';

class CrossGroupSettleUpService {
  late final FirebaseService _firebaseService;
  late final MyUser _currentUser;
  late final AllGroupsController _allGroupsController;

  CrossGroupSettleUpService() {
    _firebaseService = Get.find<FirebaseService>();
    _currentUser = Get.find<MyUser>();
    _allGroupsController = Get.find<AllGroupsController>();
  }

  Future<List<CrossGroupSuggestion>> fetchCrossGroupSuggestions() async {
    final groupIds = _allGroupsController.groups.map((g) => g.groupId).toList();
    final groupNames = {for (var g in _allGroupsController.groups) g.groupId: g.groupName};
    
    if (groupIds.isEmpty) return [];

    // Fetch all members of these groups
    List<GroupMembers> allMembers = [];
    for (var i = 0; i < groupIds.length; i += 30) {
      final chunk = groupIds.sublist(i, i + 30 > groupIds.length ? groupIds.length : i + 30);
      final membersSnap = await _firebaseService.groupMembersRef
          .where('groupId', whereIn: chunk)
          .get();
      allMembers.addAll(membersSnap.docs.map((doc) => doc.data()));
    }

    // Group by groupId
    Map<String, List<GroupMembers>> membersByGroup = {};
    for (var member in allMembers) {
      membersByGroup.putIfAbsent(member.groupId, () => []).add(member);
    }

    // Aggregate simplified debts
    Map<String, CrossGroupSuggestion> aggregated = {};
    
    membersByGroup.forEach((groupId, groupMembers) {
      final groupSuggestions = DebtSimplifier.simplify(groupMembers);
      final groupName = groupNames[groupId] ?? Strings.unknownGroup;

      for (var s in groupSuggestions) {
        if (s.fromId != _currentUser.memberId && s.toId != _currentUser.memberId) continue;

        bool isNormalOrder = s.fromId.compareTo(s.toId) < 0;
        String key = isNormalOrder ? "${s.fromId}_${s.toId}" : "${s.toId}_${s.fromId}";
        double directedAmount = isNormalOrder ? s.amount : -s.amount;

        if (!aggregated.containsKey(key)) {
          aggregated[key] = CrossGroupSuggestion(
            fromId: isNormalOrder ? s.fromId : s.toId,
            fromName: isNormalOrder ? s.fromName : s.toName,
            toId: isNormalOrder ? s.toId : s.fromId,
            toName: isNormalOrder ? s.toName : s.fromName,
            amount: 0,
            groupBreakdown: {},
          );
        }

        final current = aggregated[key]!;
        current.groupBreakdown[groupId] = (
          groupName: groupName, 
          amount: directedAmount, 
          transitivePayments: groupSuggestions.where((gs) => 
            (gs.fromId == s.fromId && gs.toId == s.toId) || 
            (gs.fromId == s.toId && gs.toId == s.fromId)
          ).toList()
        );
      }
    });

    // Finalize suggestions
    List<CrossGroupSuggestion> finalSuggestions = [];
    aggregated.forEach((key, s) {
      double netAmount = s.groupBreakdown.values.fold(0, (acc, val) => acc + val.amount);
      if (netAmount.abs() < 0.01) return;

      if (netAmount > 0) {
        finalSuggestions.add(CrossGroupSuggestion(
          fromId: s.fromId,
          fromName: s.fromName,
          toId: s.toId,
          toName: s.toName,
          amount: netAmount,
          groupBreakdown: s.groupBreakdown,
        ));
      } else {
        Map<String, ({String groupName, double amount, List<SuggestedPayment> transitivePayments})> reversedBreakdown = {};
        s.groupBreakdown.forEach((gid, data) {
          reversedBreakdown[gid] = (
            groupName: data.groupName, 
            amount: -data.amount,
            transitivePayments: data.transitivePayments
          );
        });

        finalSuggestions.add(CrossGroupSuggestion(
          fromId: s.toId,
          fromName: s.toName,
          toId: s.fromId,
          toName: s.fromName,
          amount: netAmount.abs(),
          groupBreakdown: reversedBreakdown,
        ));
      }
    });
    
    return finalSuggestions;
  }

  Future<void> settleCrossGroupSuggestion(CrossGroupSuggestion suggestion) async {
    for (var entry in suggestion.groupBreakdown.entries) {
      String groupId = entry.key;
      double amount = entry.value.amount;
      
      if (amount.abs() < 0.01) continue;
      
      String payerId = amount > 0 ? suggestion.fromId : suggestion.toId;
      String owerId = amount > 0 ? suggestion.toId : suggestion.fromId;
      String payerName = amount > 0 ? suggestion.fromName : suggestion.toName;
      String owerName = amount > 0 ? suggestion.toName : suggestion.fromName;

      final transaction = MyTransaction(
        title: payerName,
        totalAmount: BaseUtil.getFormattedCurrency(amount.abs().toString()),
        subtitle: owerName,
        transactionType: TransactionType.payment,
        paidMap: {payerId: amount.abs()},
        owedMap: {owerId: amount.abs()},
      );
      
      await _firebaseService.addTransaction(groupId: groupId, transaction: transaction);
    }
  }
}
