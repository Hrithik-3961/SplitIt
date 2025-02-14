import 'package:get/get.dart';
import 'package:splitit/controllers/all_groups_controller.dart';
import 'package:splitit/models/user.dart';

class GroupsOverviewService {
  late List<User> _members;
  List<User> get members => _members;

  GroupsOverviewService(int groupId) {
    _members = Get.find<AllGroupsController>().groupDetails.firstWhere((group) => group.id == groupId).members.obs;
  }

  void addMember() {
    _members.add(User(name: "New Member"));
  }

}