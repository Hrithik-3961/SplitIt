import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitit/enums/group_role.dart';

class GroupMembers {
  final String groupId;
  final String uid;
  final String name;
  final GroupRole role;
  final DateTime joinedAt;
  double _balance;

  GroupMembers({
    required this.groupId,
    required this.uid,
    required this.name,
    required this.role,
    double balance = 0.0,
    DateTime? joinedAt,
  }) : _balance = balance,
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
      uid: json['uid'],
      name: json['name'],
        role: GroupRole.from(json['role']),
        balance: json['balance'],
        joinedAt: (json['joinedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'uid': uid,
      'name': name,
      'role': role.name,
      'balance': balance,
      'joinedAt': joinedAt,
    };
  }
}