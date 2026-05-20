import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:splitit/components/empty_list_view.dart';
import 'package:splitit/components/transaction_tile.dart';
import 'package:splitit/components/overview_tile.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/group_overview_controller.dart';

class GroupOverviewPage extends GetView<GroupOverviewController> {
  const GroupOverviewPage({super.key});

  static const String route = "/groupsOverview";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.groupName),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              onPressed: () => controller.handleAddMember(Strings.addMember),
            ),
          ],
        ),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: controller.fabKey,
          type: ExpandableFabType.up,
          distance: 70,
          childrenAnimation: ExpandableFabAnimation.none,
          overlayStyle: const ExpandableFabOverlayStyle(blur: 2),
          children: [
            FloatingActionButton.extended(
              heroTag: Strings.addExpense,
              label: const Text(Strings.addExpense),
              icon: const Icon(Icons.add),
              onPressed: controller.navigateToAddExpensePage,
            ),
            FloatingActionButton.extended(
              heroTag: Strings.recordPayment,
              label: const Text(Strings.recordPayment),
              icon: const Icon(Icons.payment),
              onPressed: controller.navigateToRecordPaymentPage,
            ),
            FloatingActionButton.extended(
              heroTag: Strings.settleUp,
              label: const Text(Strings.settleUp),
              icon: const Icon(Icons.done_all),
              onPressed: controller.navigateToSettleUpPage,
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.pie_chart_outline, size: Values.smallIconSize),
                        SizedBox(width: Values.defaultHorizontalGap),
                        Text(Strings.overview),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: Values.smallIconSize),
                        SizedBox(width: Values.defaultHorizontalGap),
                        Text(Strings.transactions),
                      ],
                    ),
                  )
                ],
              ),
              Expanded(
                child: TabBarView(children: [
                  Obx(() => ListView.builder(
                    padding: Values.defaultPadding,
                    itemBuilder: (context, item) {
                      final user = controller.members[item];
                      return OverviewTile(
                        user: user,
                        onTap: () {},
                      );
                    },
                    itemCount: controller.members.length,
                  ),),
                  Obx(() => controller.transactions.isEmpty
                      ? const EmptyListView(icon: Icons.receipt_outlined, text: Strings.noExpensesMsg)
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final expense = controller.transactions[index];
                            return TransactionTile(
                              transaction: expense,
                              onTap: () {},
                            );
                          },
                          itemCount: controller.transactions.length,
                        ))
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
