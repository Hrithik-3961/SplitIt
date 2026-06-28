import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/empty_list_view.dart';
import 'package:splitit/components/groups_tile.dart';
import 'package:splitit/components/skeleton_loader.dart';
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
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            onPressed: controller.navigateToCrossGroupSettleUp,
            tooltip: Strings.crossGroupSettleUp,
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: controller.navigateToSettings,
            tooltip: Strings.settings,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.onNewGroupOptionsClicked,
        label: const Text(Strings.newGroup),
        icon: const Icon(Icons.add),
      ),
      body: Obx(
        () => AnimatedSwitcher(
          duration: Values.smallAnimationDuration,
          child: controller.isLoading
              ? const SkeletonLoader(height: 80, key: ValueKey('loading'),)
              : controller.groups.isEmpty
                  ? EmptyListView(
                      key: const ValueKey('empty'),
                      icon: Icons.group_outlined,
                      text: Strings.noGroupsMsg,
                      child: ElevatedButton(
                        onPressed: controller.onNewGroupOptionsClicked,
                        child: const Text(Strings.createFirstGroupMsg),
                      ),
                    )
                  : ListView.builder(
                      key: const ValueKey('content'),
                      padding: Values.defaultPadding,
                      itemBuilder: (context, item) {
                        final group = controller.groups[item];
                        return GroupsTile(
                            title: group.groupName,
                            onTap: () => controller
                                .navigateToGroupsOverview(group.groupId));
                      },
                      itemCount: controller.groups.length),
        ),
      ),
    );
  }
}
