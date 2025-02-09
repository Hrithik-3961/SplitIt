import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/groups_tile.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/all_groups_controller.dart';

class AllGroupsPage extends GetView<HomeController> {
  const AllGroupsPage({super.key});

  static const String route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          PopupMenuButton(
              onSelected: (item) => controller.handlePopUpMenuClick(item),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: Strings.createAGroup,
                        child: Text(Strings.createAGroup)),
                    const PopupMenuItem(
                        value: Strings.joinAGroup,
                        child: Text(Strings.joinAGroup))
                  ])
        ],
      ),
      body: Obx(
        () => ListView.builder(
            padding: const EdgeInsets.only(top: 22.0, left: 16.0, right: 16.0),
            itemBuilder: (context, item) => GroupsTile(
                title: "lorem epsum",
                onTap: () => controller.navigateToGroupsOverview("lorem epsum")),
            itemCount: controller.groupsCount.value),
      ),
    );
  }
}
