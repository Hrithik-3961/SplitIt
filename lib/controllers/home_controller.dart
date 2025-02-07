import 'package:get/get.dart';

class HomeController extends GetxController {
  var count = 1.obs;
}

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }

}