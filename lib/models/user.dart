class User {
  final String _name;
  final double _totalAmountOwed;

  User({required String name, double totalAmountOwed = 0})
      : _name = name,
        _totalAmountOwed = totalAmountOwed;

  String get name => _name;

  double get totalAmountOwed => _totalAmountOwed;
}
