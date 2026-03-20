enum SplitType {
  evenly('Split evenly'),
  shares('Split by shares'),
  percentages('Split by percentages'),
  amounts('Split by amounts');

  final String _value;

  String get value => _value;

  const SplitType(this._value);

  factory SplitType.from(String value) {
    switch (value) {
      case 'evenly':
        return SplitType.evenly;
      case 'shares':
        return SplitType.shares;
      case 'percentages':
        return SplitType.percentages;
      case 'amounts':
        return SplitType.amounts;
      default:
        throw Exception('Invalid split type: $value');
    }
  }
}