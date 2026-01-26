import 'package:get/get.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/models/transaction.dart';

class GroupDetails {
  final int _id;
  final String _title;
  final RxList<MyUser> _members;
  final RxList<Transaction> _transactions = <Transaction>[].obs;

  GroupDetails({required id, required title, required members})
      : _id = id,
        _title = title,
        _members = members;

  int get id => _id;

  String get title => _title;

  RxList<MyUser> get members => _members;

  RxList<Transaction> get transactions => _transactions;
}
