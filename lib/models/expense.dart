class Expense {
  final String _title;
  final String _amount;
  final String _paidBy;

  Expense(
      {required String title, required String amount, required String paidBy})
      : _title = title,
        _amount = amount,
        _paidBy = paidBy;

  String get title => _title;

  String get amount => _amount;

  String get paidBy => _paidBy;
}
