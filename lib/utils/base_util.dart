import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class BaseUtil {
  static double? getNumericValue(String currencyString) {
    return double.tryParse(toNumericString(currencyString, allowPeriod: true));
  }
}
