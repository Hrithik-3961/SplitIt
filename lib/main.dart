import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/themes.dart';
import 'package:splitit/controllers/home_controller.dart';
import 'package:splitit/pages/home.dart';

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
      initialRoute: HomePage.route,
      getPages: [
        GetPage(name: HomePage.route, page: () => HomePage(), binding: HomeBinding()),
      ],
    );
  }
}