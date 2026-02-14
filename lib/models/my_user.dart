import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  final String? phone;
  final String name;
  final bool isGuest;
  double _totalAmountOwed;

  MyUser({required this.uid, this.name = "My User", this.phone, required this.isGuest, double totalAmountOwed = 0})
      :_totalAmountOwed = totalAmountOwed;

  double get totalAmountOwed => _totalAmountOwed;

  void subtractAmount(double value) {
    _totalAmountOwed -= value;
  }

  void addAmount(double value) {
    _totalAmountOwed += value;
  }

  factory MyUser.fromJson(Map<String, dynamic> json) {
    return MyUser(
      uid: json['uid'],
      name: json['name'],
      phone: json['phone'] ?? '',
      isGuest: json['isGuest'] ?? false,
      totalAmountOwed: json['balance'] != null ? json['balance'].toDouble() : 0.0
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'isGuest': isGuest,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

}
