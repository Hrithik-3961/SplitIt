import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitit/enums/group_role.dart';

class GroupMembers {
  final String groupId;
  final String memberId;
  final String? uid;
  final String? phone;
  final String name;
  final GroupRole role;
  final DateTime joinedAt;
  double _balance;

  GroupMembers({
    required this.groupId,
    required this.memberId,
    this.uid,
    this.phone,
    required this.name,
    required this.role,
    double balance = 0.0,
    DateTime? joinedAt,
  })  : _balance = balance,
        joinedAt = joinedAt ?? DateTime.now();

  double get balance => _balance;

  void subtractAmount(double value) {
    _balance -= value;
  }

  void addAmount(double value) {
    _balance += value;
  }

  factory GroupMembers.fromJson(Map<String, dynamic> json) {
    return GroupMembers(
      groupId: json['groupId'],
      memberId: json['memberId'] ?? json['uid'],
      uid: json['uid'],
      phone: json['phone'],
      name: json['name'],
      role: GroupRole.from(json['role']),
      balance: (json['balance'] as num).toDouble(),
      joinedAt: (json['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'memberId': memberId,
      'uid': uid,
      'phone': phone,
      'name': name,
      'role': role.name,
      'balance': balance,
      'joinedAt': joinedAt,
    };
  }
}
