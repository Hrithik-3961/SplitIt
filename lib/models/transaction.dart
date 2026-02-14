class Transaction {
  final String title;
  final String amount;
  final String subtitle;
  final TransactionType type;

  Transaction({
    required this.title,
    required this.amount,
    required this.subtitle,
    required this.type,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'],
      amount: json['amount'],
      subtitle: json['subtitle'],
      type: TransactionType.from(json['type']),
    );
  }


}

enum TransactionType {
  expense,
  payment;

  factory TransactionType.from(String value) {
    switch (value) {
      case 'expense':
        return TransactionType.expense;
      case 'payment':
        return TransactionType.payment;
      default:
        throw Exception('Invalid transaction type: $value');
    }
  }
}
