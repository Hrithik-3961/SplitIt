import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/groups_tile.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/all_groups_controller.dart';

class AllGroupsPage extends GetView<AllGroupsController> {
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
        () => controller.groups.isEmpty
            ? const Center(
                child: Text(
                  Strings.noGroupsMsg,
                  textAlign: TextAlign.center,
                ),
              )
            : ListView.builder(
                padding: Values.defaultListPadding,
                itemBuilder: (context, item) {
                  final group = controller.groups[item];
                  return GroupsTile(
                      title: group.groupName,
                      onTap: () =>
                          controller.navigateToGroupsOverview(group.groupId));
                },
                itemCount: controller.groups.length),
      ),
    );
  }
}
