import 'package:get/get.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/models/expense.dart';

class GroupDetails {
  final int _id;
  final String _title;
  final List<User> _members;
  final List<Expense> _expenses = <Expense>[].obs;

  GroupDetails({required id, required title, required members})
      : _id = id,
        _title = title,
        _members = members;

  int get id => _id;

  String get title => _title;

  List<User> get members => _members;

  List<Expense> get expenses => _expenses;
}
