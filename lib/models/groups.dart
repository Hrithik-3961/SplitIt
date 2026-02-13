import 'package:cloud_firestore/cloud_firestore.dart';

class Groups {
  final String groupId;
  final String groupName;
  final String role;

  Groups({required this.groupId, required this.groupName, required this.role});

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
        groupId: json['groupId'],
        groupName: json['groupName'],
        role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'role': role,
      'joinedAt': FieldValue.serverTimestamp()
    };
  }
}