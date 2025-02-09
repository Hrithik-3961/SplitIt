import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/themes.dart';
import 'package:splitit/controllers/all_groups_controller.dart';
import 'package:splitit/pages/all_groups_page.dart';
import 'package:splitit/pages/group_overview_page.dart';
import 'package:splitit/controllers/group_overview_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      themeMode: ThemeMode.system,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      initialRoute: AllGroupsPage.route,
      getPages: [
        GetPage(name: AllGroupsPage.route, page: () => const AllGroupsPage(), binding: HomeBinding()),
        GetPage(name: GroupOverviewPage.route, page: () => const GroupOverviewPage(), binding: GroupOverviewBinding()),
      ],
    );
  }
}