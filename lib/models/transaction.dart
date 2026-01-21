class Transaction {
  final String _title;
  final String _amount;
  final String _subtitle;
  final TransactionType _type;

  Transaction(
      {required String title,
      required String amount,
      required String subtitle,
      required TransactionType type})
      : _title = title,
        _amount = amount,
        _subtitle = subtitle,
        _type = type;

  String get title => _title;

  String get amount => _amount;

  String get subtitle => _subtitle;

  TransactionType get type => _type;
}

enum TransactionType {
  expense,
  payment,
}
