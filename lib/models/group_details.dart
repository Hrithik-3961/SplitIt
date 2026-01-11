import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/models/expense.dart';

class GroupDetails {
  final int _id;
  final String _title;
  final RxList<User> _members;
  final RxList<Expense> _expenses = <Expense>[].obs;

  GroupDetails({required id, required title, required members})
      : _id = id,
        _title = title,
        _members = members;

  int get id => _id;

  String get title => _title;

  RxList<User> get members => _members;

  RxList<Expense> get expenses => _expenses;
}
