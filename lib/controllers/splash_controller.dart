import 'package:get/get.dart';
import 'package:splitit/services/firebase_service.dart';

import '../pages/all_groups_page.dart';
import '../pages/login_page.dart';
import 'login_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    final auth = Get.find<LoginController>();

    auth.firebaseUser.stream.first.then((user) {
      if (user == null) {
        Get.offAllNamed(LoginPage.route);
      } else {
        Get.offAllNamed(AllGroupsPage.route);
      }
    });
  }
}

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<FirebaseService>(() async => await FirebaseService().init(),
        permanent: true);
    Get.lazyPut(() => LoginController());
  }
}
