import 'package:cloud_firestore/cloud_firestore.dart';

class MyTransaction {
  final String title;
  final String totalAmount;
  final String subtitle;
  final TransactionType transactionType;
  final SplitType? splitType;
  final Map<String, double> paidMap; // userId -> amountPaid
  final Map<String, double> owedMap; // userId -> amountOwed

  MyTransaction({
    required this.title,
    required this.totalAmount,
    required this.subtitle,
    required this.transactionType,
    this.splitType,
    this.paidMap = const {},
    this.owedMap = const {},
  });

  factory MyTransaction.fromJson(Map<String, dynamic> json) {
    return MyTransaction(
        title: json['title'],
        totalAmount: json['totalAmount'],
        subtitle: json['subtitle'],
        transactionType: TransactionType.from(json['transactionType']),
        splitType: json['splitType'] != null
            ? SplitType.from(json['splitType'])
            : null,
        paidMap: json['paidMap'] != null
            ? (json['paidMap'] as Map<String, dynamic>)
                .map((k, v) => MapEntry(k, (v as num).toDouble()))
            : {},
        owedMap: json['owedMap'] != null
            ? (json['owedMap'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, (v as num).toDouble()))
            : {});
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'totalAmount': totalAmount,
      'subtitle': subtitle,
      'splitType': splitType?.name,
      'transactionType': transactionType.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'paidMap': paidMap,
      'owedMap': owedMap,
    };
  }
}

enum TransactionType {
  expense,
  payment;

  factory TransactionType.from(String value) {
    switch (value) {
      case 'expense':
        return TransactionType.expense;
      case 'payment':
        return TransactionType.payment;
      default:
        throw Exception('Invalid transaction type: $value');
    }
  }
}

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
