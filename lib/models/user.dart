class User {
  final String _name;
  double _totalAmountOwed;

  User({required String name, double totalAmountOwed = 0})
      : _name = name,
        _totalAmountOwed = totalAmountOwed;

  String get name => _name;

  double get totalAmountOwed => _totalAmountOwed;

  void addExpense(double value) {
    _totalAmountOwed -= value;
  }

  void addPayment(double value) {
    _totalAmountOwed += value;
  }
}
