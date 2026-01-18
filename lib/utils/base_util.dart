import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/add_expense_controller.dart';

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

  static ({double splitAmount, double paidAmount}) getUserAmounts(UserExpenseData expenseData) {
    double splitAmount = getNumericValue(expenseData.splitAmountController.text) ?? 0;
    double paidAmount = getNumericValue(expenseData.paidByController.text) ?? 0;

    return (splitAmount: splitAmount, paidAmount: paidAmount);
  }

}
