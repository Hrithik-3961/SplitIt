import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/group_overview_controller.dart';

class GroupOverviewPage extends GetView<GroupOverviewController> {
  const GroupOverviewPage({super.key});

  static const String route = "/groupsOverview";

  @override
  Widget build(BuildContext context) {
    String title = Get.parameters["title"] ?? "";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text(Strings.addExpense),
            icon: const Icon(Icons.add),
            onPressed: () => controller.handleAddExpense,
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text(Strings.recordPayment),
            icon: const Icon(Icons.payment),
            onPressed: () => controller.handleRecordPayment,
          ),
        ],
      ),
    );
  }
}
