import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/components/expense_tile.dart';
import 'package:splitit/components/overview_tile.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/group_overview_controller.dart';

class GroupOverviewPage extends GetView<GroupOverviewController> {
  const GroupOverviewPage({super.key});

  static const String route = "/groupsOverview";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(controller.groupName),
        actions: [
          PopupMenuButton(
              onSelected: (item) => controller.handleAddMember(item),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: Strings.addMember,
                        child: Text(Strings.addMember))
                  ])
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        key: controller.fabKey,
        type: ExpandableFabType.up,
        childrenAnimation: ExpandableFabAnimation.none,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text(Strings.addExpense),
            icon: const Icon(Icons.add),
            onPressed: controller.navigateToAddExpensePage,
          ),
          FloatingActionButton.extended(
            heroTag: null,
            label: const Text(Strings.recordPayment),
            icon: const Icon(Icons.payment),
            onPressed: controller.navigateToRecordPaymentPage,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: Strings.overview,),
                Tab(text: Strings.expense,)
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Obx(() => ListView.separated(
                  padding: Values.defaultListPadding,
                  itemBuilder: (context, item) {
                    final user = controller.members[item];
                    return OverviewTile(
                      user: user,
                      onTap: () {},
                    );
                  },
                  itemCount: controller.members.length,
                  separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
                ),),
                Obx(() => controller.expenses.isEmpty
                    ? const Center(
                        child: Text(
                          Strings.noExpensesMsg,
                        ),
                      )
                    : ListView.separated(
                        padding: Values.defaultListPadding,
                        itemBuilder: (context, item) {
                          final expense = controller.expenses[item];
                          return ExpenseTile(
                            expense: expense,
                            onTap: () {},
                          );
                        },
                        itemCount: controller.expenses.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ))
              ]),
            )
          ],
        ),
      ),
    );
  }
}
