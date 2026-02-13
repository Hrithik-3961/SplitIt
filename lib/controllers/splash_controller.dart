import 'package:get/get.dart';
import 'package:splitit/services/firebase_service.dart';

import '../pages/all_groups_page.dart';
import '../pages/login_page.dart';
import '../services/login_service.dart';
import 'login_controller.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    Get.put(LoginService(), permanent: true);
    Get.put(LoginController(), permanent: true);
    final loginController = Get.find<LoginController>();

    loginController.firebaseUser.stream.first.then((user) async {
      if (user == null) {
        Get.offAllNamed(LoginPage.route);
      } else {
        final firebaseService = Get.find<FirebaseService>();
        bool isLoggedIn = await firebaseService.setCurrentUser();
        if (!isLoggedIn) {
          return;
        }

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
  }
}
