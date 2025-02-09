import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupOverViewPage extends StatelessWidget {
  const GroupOverViewPage({super.key});

  static const String route = "/groupsOverview";

  @override
  Widget build(BuildContext context) {
    String title = Get.parameters["title"] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(title),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
