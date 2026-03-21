class Expense {
  final String transactionId;
  final String groupId;
  final String userId;
  final double amount;

  Expense({
    required this.transactionId,
    required this.groupId,
    required this.userId,
    required this.amount,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      transactionId: json['transactionId'],
      groupId: json['groupId'],
      userId: json['userId'],
      amount: json['amountPaid'] != null
          ? (json['amountPaid'] as num).toDouble()
          : (json['owedAmount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson(bool isPayer) {
    return {
      'transactionId': transactionId,
      'groupId': groupId,
      'userId': userId,
      isPayer ? 'amountPaid': 'owedAmount' : amount,
    };
  }
}
