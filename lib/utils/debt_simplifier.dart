import '../models/group_members.dart';
import '../models/suggested_payment.dart';

class DebtSimplifier {
  static List<SuggestedPayment> simplify(List<GroupMembers> members) {

    List<GroupMembers> debtors = members.where((m) => m.balance < -0.01).toList();
    List<GroupMembers> creditors = members.where((m) => m.balance > 0.01).toList();

    debtors.sort((a, b) => a.balance.compareTo(b.balance));
    creditors.sort((a, b) => b.balance.compareTo(a.balance));

    List<SuggestedPayment> suggestions = [];

    int dIndex = 0;
    int cIndex = 0;

    List<double> debtorBalances = debtors.map((m) => m.balance.abs()).toList();
    List<double> creditorBalances = creditors.map((m) => m.balance).toList();

    while (dIndex < debtors.length && cIndex < creditors.length) {
      double dBal = debtorBalances[dIndex];
      double cBal = creditorBalances[cIndex];

      double settleAmount = dBal < cBal ? dBal : cBal;

      if (settleAmount > 0.01) {
        suggestions.add(SuggestedPayment(
          fromId: debtors[dIndex].memberId,
          fromName: debtors[dIndex].name,
          toId: creditors[cIndex].memberId,
          toName: creditors[cIndex].name,
          amount: settleAmount,
        ));
      }

      debtorBalances[dIndex] -= settleAmount;
      creditorBalances[cIndex] -= settleAmount;

      if (debtorBalances[dIndex] < 0.01) dIndex++;
      if (creditorBalances[cIndex] < 0.01) cIndex++;
    }

    return suggestions;
  }
}
