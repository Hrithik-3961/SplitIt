import 'package:get/get.dart';

class AddExpenseController extends GetxController {

}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseController());
  }

}