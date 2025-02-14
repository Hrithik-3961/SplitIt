import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/groups_overview_service.dart';

class GroupOverviewController extends GetxController {

  late GroupsOverviewService _groupsOverviewService;
  List<User> get members => _groupsOverviewService.members;

  @override
  void onInit() {
    super.onInit();
    int groupId = int.parse(Get.currentRoute.split('/').last);
    _groupsOverviewService = Get.put(GroupsOverviewService(groupId));
  }

  void handleAddMember(String item) {
    switch (item) {
      case Strings.addMember:
        _groupsOverviewService.addMember();
        break;
    }
  }

  void handleAddExpense() {}

  void handleRecordPayment() {}

}

class GroupOverviewBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => GroupOverviewController());
  }

}