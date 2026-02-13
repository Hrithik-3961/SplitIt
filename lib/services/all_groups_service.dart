import 'package:get/get.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/my_user.dart';

import 'firebase_service.dart';

class AllGroupsService {
  late final FirebaseService _firebaseService;
  late List<GroupDetails> _groups;

  List<GroupDetails> get groupDetails => _groups;

  AllGroupsService() {
    _init();
  }

  void _init() {
    _firebaseService = Get.find<FirebaseService>();
    _groups = [
      GroupDetails(
          id: "1",
          title: "Group 1",
          members: [
            MyUser(name: "Name 1", uid: '1', isGuest: true),
            MyUser(name: "Name 2", uid: '2', isGuest: true)
          ].obs)
    ].obs;
  }

  void addGroup(String title) async {
    GroupDetails newGroup =
        await _firebaseService.createGroup(groupName: title);
    _groups.add(newGroup);
  }

  void joinGroup(String inviteCode) async {
    await _firebaseService.joinGroup(inviteCode: inviteCode);
  }
}
