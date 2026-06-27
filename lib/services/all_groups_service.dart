import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/my_user.dart';

import '../models/groups.dart';
import 'firebase_service.dart';

class AllGroupsService {
  late final FirebaseService _firebaseService;
  final _groups = <Groups>[].obs;
  final RxBool isLoading = true.obs;

  List<Groups> get groups => _groups;

  AllGroupsService() {
    _init();
  }

  void _init() {
    _firebaseService = Get.find<FirebaseService>();
    final currentUser = Get.find<MyUser>();

    isLoading.value = true;
    Future.wait([
      _firebaseService.usersRef
          .doc(currentUser.uid)
          .collection('groups')
          .get(),
      Future.delayed(Values.defaultAnimationDuration),
    ]).then((results) {
      final userGroupsSnap = results[0] as QuerySnapshot<Map<String, dynamic>>;
      final groups = userGroupsSnap.docs.map((doc) {
        final data = doc.data();
        return Groups.fromJson(data);
      }).toList();
      _groups.assignAll(groups);
      isLoading.value = false;
    }).catchError((e) {
      isLoading.value = false;
    });
  }

  Future<void> addGroup(String title) async {
    Groups newGroup =
        await _firebaseService.createGroup(groupName: title);
    _groups.add(newGroup);
  }

  Future<void> joinGroup(String inviteCode) async {
    Groups newGroup = await _firebaseService.joinGroup(inviteCode: inviteCode);
    _groups.add(newGroup);
  }
}
