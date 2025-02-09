import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/pages/group_overview_page.dart';

class HomeController extends GetxController {

  var groupsCount = 2.obs;

  void handlePopUpMenuClick(String name) {
    switch (name) {
      case Strings.createAGroup:
        groupsCount++;
        break;
      case Strings.joinAGroup:
        groupsCount++;
        break;
    }
  }

  void navigateToGroupsOverview(String title) => Get.toNamed("${GroupOverviewPage.route}?title=$title");

}

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }

}