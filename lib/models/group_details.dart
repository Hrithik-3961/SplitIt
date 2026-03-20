import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/transaction.dart';

class GroupDetails {
  final String id;
  final String title;
  final String createdBy;
  final DateTime createdAt;
  final String currency;
  final int memberCount;
  final double totalExpense;
  final String inviteCode;
  final RxList<GroupMembers> members;
  final RxList<MyTransaction> transactions;

  GroupDetails(
      {required this.id,
      required this.title,
      required this.createdBy,
      required this.memberCount,
      required this.totalExpense,
      required this.inviteCode,
      required this.members,
      this.currency = 'INR',
      DateTime? createdAt,
      RxList<MyTransaction>? transactions})
      : transactions = transactions ?? <MyTransaction>[].obs,
        createdAt = createdAt ?? DateTime.now();

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
        id: json['groupId'],
        title: json['name'],
        createdBy: json['createdBy'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
        currency: json['currency'],
        memberCount: json['memberCount'],
        totalExpense: json['totalExpense'],
        inviteCode: json['inviteCode'],
        members: <GroupMembers>[].obs);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'createdBy': createdBy,
      'createdAt': FieldValue.serverTimestamp(),
      'currency': currency,
      'memberCount': memberCount,
      'totalExpense': totalExpense,
      'inviteCode': inviteCode,
    };
  }
}
