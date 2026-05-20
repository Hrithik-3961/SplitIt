import 'package:get/get.dart';
import 'package:splitit/controllers/group_overview_controller.dart';
import 'package:splitit/enums/transaction_type.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/models/suggested_payment.dart';
import 'package:splitit/utils/debt_simplifier.dart';

class SettleUpService {
  late final RxList<GroupMembers> _members;

  SettleUpService() {
    _members = Get.find<GroupOverviewController>().members;
  }

  List<SuggestedPayment> getSuggestions() {
    return DebtSimplifier.simplify(_members);
  }

  MyTransaction createSettleTransaction(SuggestedPayment suggestion) {
    // Update local balances for immediate UI feedback
    final fromMember = _members.firstWhere((m) => m.memberId == suggestion.fromId);
    final toMember = _members.firstWhere((m) => m.memberId == suggestion.toId);
    
    fromMember.addAmount(suggestion.amount);
    toMember.subtractAmount(suggestion.amount);
    
    _members.refresh();

    return MyTransaction(
      title: suggestion.fromName,
      totalAmount: suggestion.amount.toStringAsFixed(2),
      subtitle: suggestion.toName,
      transactionType: TransactionType.payment,
      paidMap: {suggestion.fromId: suggestion.amount},
      owedMap: {suggestion.toId: suggestion.amount},
    );
  }
}
