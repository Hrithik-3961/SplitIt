import 'package:cloud_firestore/cloud_firestore.dart';

import '../enums/split_type.dart';
import '../enums/transaction_type.dart';

class MyTransaction {
  String? groupId;
  final String title;
  final String totalAmount;
  final String subtitle;
  final TransactionType transactionType;
  final SplitType? splitType;
  final Map<String, double> paidMap; // memberId -> amountPaid
  final Map<String, double> owedMap; // memberId -> amountOwed

  MyTransaction({
    required this.title,
    required this.totalAmount,
    required this.subtitle,
    required this.transactionType,
    this.groupId,
    this.splitType,
    this.paidMap = const {},
    this.owedMap = const {},
  });

  factory MyTransaction.fromJson(Map<String, dynamic> json) {
    return MyTransaction(
        groupId: json['groupId'],
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
      'groupId': groupId,
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

