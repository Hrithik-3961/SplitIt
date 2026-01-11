import 'package:get/get.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/user.dart';

class AllGroupsService {
  late List<GroupDetails> _groups;
  List<GroupDetails> get groupDetails => _groups;

  AllGroupsService() {
    _init();
  }

  void _init() {
    _groups = [
      GroupDetails(id: 1, title: "Group 1", members: [User(name: "Name 1"), User(name: "Name 2")].obs)
    ].obs;
  }

  void addGroup() {
    _groups.add(
      GroupDetails(
          id: _groups.length + 1,
          title: "New Group",
          members: [User(name: "New Name 1"), User(name: "New Name 2")].obs),
    );
  }
}
