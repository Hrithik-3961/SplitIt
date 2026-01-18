import 'package:splitit/utils/base_util.dart';

import '../constants/strings.dart';

class ExpenseValidator {
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final parsedValue = BaseUtil.getNumericValue(value);
    if (parsedValue == null) {
      return 'Invalid number';
    }

    if (parsedValue <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }

  static String? validateSplit(double totalPaidByAmount, double totalAmount, double totalSplitAmount) {

    if(totalPaidByAmount == 0) {
      return Strings.paidByError;
    }

    final difference = totalSplitAmount - totalAmount;
    if (difference.isNegative) {
      return "${Strings.shortBy} ${BaseUtil.getFormattedCurrency(difference.abs().toString())}";
    } else if (difference > 0) {
      return "${Strings.exceedsBy} ${BaseUtil.getFormattedCurrency(difference.toString())}";
    }

    return null;
  }
}
