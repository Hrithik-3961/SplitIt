import 'package:get/get.dart';

class GroupOverviewController extends GetxController {

  void handleAddExpense() {}

  void handleRecordPayment() {}

}

class GroupOverviewBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => GroupOverviewController());
  }

}