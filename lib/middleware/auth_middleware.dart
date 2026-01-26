import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/controllers/login_controller.dart';
import 'package:splitit/pages/login_page.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<LoginController>();

    if (!auth.isLoggedIn) {
      return const RouteSettings(name: LoginPage.route);
    }
    return null;
  }
}
