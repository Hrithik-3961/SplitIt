import 'package:get/get.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/my_user.dart';

import '../models/groups.dart';
import 'firebase_service.dart';

class AllGroupsService {
  late final FirebaseService _firebaseService;
  final _groups = <Groups>[].obs;

  List<Groups> get groups => _groups;

  AllGroupsService() {
    _init();
  }

  void _init() {
    _firebaseService = Get.find<FirebaseService>();
    final currentUser = Get.find<MyUser>();

    _firebaseService.usersRef
        .doc(currentUser.uid)
        .collection('groups')
        .get()
        .then((userGroupsSnap) => userGroupsSnap.docs.map((doc) {
              final data = doc.data();
              return Groups.fromJson(data);
            }).toList())
    .then((groups) => _groups.addAll(groups));
  }

  void addGroup(String title) async {
    GroupDetails newGroup =
        await _firebaseService.createGroup(groupName: title);
    // _groups.add(newGroup);
  }

  void joinGroup(String inviteCode) async {
    await _firebaseService.joinGroup(inviteCode: inviteCode);
  }
}
