import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class ExpenseValidator {
  static String? validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }

    final cleanedValue = toNumericString(value);
    final parsed = double.tryParse(cleanedValue);
    if (parsed == null) {
      return 'Invalid number';
    }

    if (parsed <= 0) {
      return 'Amount must be greater than 0';
    }

    return null;
  }
}
