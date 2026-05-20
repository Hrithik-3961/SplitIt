import 'suggested_payment.dart';

class CrossGroupSuggestion extends SuggestedPayment {
  final Map<String, ({String groupName, double amount, List<SuggestedPayment> transitivePayments})> groupBreakdown; // groupId -> {name, amount, transitive}

  CrossGroupSuggestion({
    required super.fromId,
    required super.fromName,
    required super.toId,
    required super.toName,
    required super.amount,
    required this.groupBreakdown,
  });
}
