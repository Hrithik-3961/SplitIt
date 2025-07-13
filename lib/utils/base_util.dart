import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:splitit/constants/strings.dart';

class BaseUtil {
  static double? getNumericValue(String currencyString) {
    return double.tryParse(toNumericString(currencyString, allowPeriod: true));
  }
  
  static String getFormattedCurrency(String value) {
    return toCurrencyString(
      value,
      leadingSymbol: Strings.rupeeSign,
      useSymbolPadding: true,
    );
  }
}
