import 'package:splitit/utils/base_util.dart';

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
}
