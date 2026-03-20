import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitit/enums/group_role.dart';

class Groups {
  final String groupId;
  final String groupName;
  final GroupRole role;

  Groups({required this.groupId, required this.groupName, required this.role});

  factory Groups.fromJson(Map<String, dynamic> json) {
    return Groups(
        groupId: json['groupId'],
        groupName: json['groupName'],
        role: GroupRole.from(json['role'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'role': role.name,
      'joinedAt': FieldValue.serverTimestamp()
    };
  }
}