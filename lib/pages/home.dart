import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  static const String route = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
      ),
      body: Column(
        children: [
          Obx(() => Text("${controller.count}")),
          ElevatedButton(
              onPressed: () {
                controller.count++;
              },
              child: Text("Count++"))
        ],
      ),
    );
  }
}
