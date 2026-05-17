class Expense {
  final String transactionId;
  final String groupId;
  final String memberId;
  final double amount;

  Expense({
    required this.transactionId,
    required this.groupId,
    required this.memberId,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      transactionId: json['transactionId'],
      groupId: json['groupId'],
      memberId: json['memberId'] ?? json['userId'],
      amount: json['amountPaid'] != null
          ? (json['amountPaid'] as num).toDouble()
          : (json['owedAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson(bool isPayer) {
    return {
      'transactionId': transactionId,
      'groupId': groupId,
      'memberId': memberId,
      isPayer ? 'amountPaid' : 'owedAmount': amount,
    };
  }
}
