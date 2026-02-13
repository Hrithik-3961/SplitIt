import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/groups.dart';
import 'package:splitit/pages/group_overview_page.dart';
import 'package:splitit/services/all_groups_service.dart';

class AllGroupsController extends GetxController {

  late AllGroupsService _groupsService;
  List<Groups> get groups => _groupsService.groups;

  @override
  void onInit() {
    super.onInit();
    _groupsService = Get.put(AllGroupsService());
  }

  void handlePopUpMenuClick(String name) {
    switch (name) {
      case Strings.createAGroup:
        _groupsService.addGroup("New Group");
        break;
      case Strings.joinAGroup:
        _groupsService.joinGroup("123456");
        break;
    }
  }

  void navigateToGroupsOverview(String groupId) {
    final group = _groupsService.groups.firstWhere((group) => group.groupId == groupId);
    Get.toNamed("${GroupOverviewPage.route}/$groupId", arguments: group.groupName);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllGroupsController());
  }
}
