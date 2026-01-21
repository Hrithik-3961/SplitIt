import 'dart:math';

class User {
  final String _id;
  final String _name;
  double _totalAmountOwed;

  User({required String name, double totalAmountOwed = 0})
      :_id = _generateSaltedId(),
        _name = name,
        _totalAmountOwed = totalAmountOwed;

  String get id => _id;

  String get name => _name;

  double get totalAmountOwed => _totalAmountOwed;

  void subtractAmount(double value) {
    _totalAmountOwed -= value;
  }

  void addAmount(double value) {
    _totalAmountOwed += value;
  }

  static String _generateSaltedId() {
    final time = DateTime.now().millisecondsSinceEpoch;
    final salt = Random.secure().nextInt(1 << 32);

    final mixed = time ^ salt; // XOR salting
    return mixed.toUnsigned(64).toString();
  }
}
