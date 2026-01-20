class Transaction {
  final String _title;
  final String _amount;
  final String _paidBy;
  final TransactionType _type;

  Transaction(
      {required String title,
      required String amount,
      required String paidBy,
      required TransactionType type})
      : _title = title,
        _amount = amount,
        _paidBy = paidBy,
        _type = type;

  String get title => _title;

  String get amount => _amount;

  String get paidBy => _paidBy;

  TransactionType get type => _type;
}

enum TransactionType {
  expense,
  payment,
}
