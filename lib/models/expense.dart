class Expense {
  String _title;
  double _amount;

  Expense({required String title, required double amount})
      : _title = title,
        _amount = amount;

  String get title => _title;
  double get amount => _amount;
}
