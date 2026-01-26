import 'package:get/get.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/my_user.dart';

class AllGroupsService {
  late List<GroupDetails> _groups;
  List<GroupDetails> get groupDetails => _groups;

  AllGroupsService() {
    _init();
  }

  void _init() {
    _groups = [
      GroupDetails(id: 1, title: "Group 1", members: [MyUser(name: "Name 1"), MyUser(name: "Name 2")].obs)
    ].obs;
  }

  void addGroup() {
    _groups.add(
      GroupDetails(
          id: _groups.length + 1,
          title: "New Group",
          members: [MyUser(name: "New Name 1"), MyUser(name: "New Name 2")].obs),
    );
  }
}
