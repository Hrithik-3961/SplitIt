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