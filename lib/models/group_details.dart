import 'package:splitit/models/user.dart';

class GroupDetails {
  final int _id;
  final String _title;
  final List<User> _members;

  GroupDetails({required id, required title, required members}) : _id = id, _title = title, _members = members;

  int get id => _id;

  String get title => _title;

  List<User> get members => _members;
}
