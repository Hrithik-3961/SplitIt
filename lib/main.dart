import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/themes.dart';
import 'package:splitit/controllers/add_expense_controller.dart';
import 'package:splitit/controllers/all_groups_controller.dart';
import 'package:splitit/controllers/login_controller.dart';
import 'package:splitit/controllers/splash_controller.dart';
import 'package:splitit/middleware/auth_middleware.dart';
import 'package:splitit/pages/login_page.dart';
import 'package:splitit/pages/splash_screen.dart';
import 'controllers/record_payment_controller.dart';
import 'package:splitit/pages/add_expense_page.dart';
import 'package:splitit/pages/all_groups_page.dart';
import 'package:splitit/pages/group_overview_page.dart';
import 'package:splitit/controllers/group_overview_controller.dart';
import 'package:splitit/pages/record_payment_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(SplashController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: SplashScreen.route,
      getPages: [
        GetPage(name: SplashScreen.route, page: () => const SplashScreen(), binding: SplashBinding()),
        GetPage(name: LoginPage.route, page: () => const LoginPage(), binding: LoginBinding()),
        GetPage(name: AllGroupsPage.route, page: () => const AllGroupsPage(), binding: HomeBinding(), middlewares: [AuthMiddleware()]),
        GetPage(name: GroupOverviewPage.route, page: () => const GroupOverviewPage(), binding: GroupOverviewBinding()),
        GetPage(name: AddExpensePage.route, page: () => const AddExpensePage(), binding: AddExpenseBinding()),
        GetPage(name: RecordPaymentPage.route, page: () => const RecordPaymentPage(), binding: RecordPaymentBinding())
      ],
    );
  }
}
