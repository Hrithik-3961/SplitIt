import 'package:get/get.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/models/transaction.dart';

class GroupDetails {
  final String id;
  final String title;
  final RxList<MyUser> members;
  final RxList<Transaction> transactions;

  GroupDetails({required this.id, required this.title, required this.members, RxList<Transaction>? transactions})
  : transactions = transactions ?? <Transaction>[].obs;

  factory GroupDetails.fromJson(Map<String, dynamic> json) {
    return GroupDetails(
      id: json['groupId'],
      title: json['name'],
      members: <MyUser>[].obs
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'groupId': id,
      // 'name': title,
      // 'phone': phone,
      // 'isGuest': isGuest,
      // 'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
