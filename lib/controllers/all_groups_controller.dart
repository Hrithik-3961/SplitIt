import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/pages/group_overview_page.dart';
import 'package:splitit/services/all_groups_service.dart';

class AllGroupsController extends GetxController {

  late AllGroupsService _groupsService;
  List<GroupDetails> get groupDetails => _groupsService.groupDetails;

  @override
  void onInit() {
    super.onInit();
    _groupsService = Get.put(AllGroupsService());
  }

  void handlePopUpMenuClick(String name) {
    switch (name) {
      case Strings.createAGroup:
        _groupsService.addGroup();
        break;
      case Strings.joinAGroup:
        _groupsService.addGroup();
        break;
    }
  }

  void navigateToGroupsOverview(int groupId) {
    final group = _groupsService.groupDetails.firstWhere((group) => group.id == groupId);
    Get.toNamed("${GroupOverviewPage.route}/$groupId", arguments: group.title);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllGroupsController());
  }
}
