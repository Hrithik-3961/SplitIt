import 'package:get/get.dart';
import 'package:splitit/controllers/all_groups_controller.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/user.dart';

class GroupsOverviewService {
  late GroupDetails _groupDetails;

  GroupDetails get groupDetails => _groupDetails;

  GroupsOverviewService(int groupId) {
    _init(groupId);
  }

  void _init(int groupId) {
    _groupDetails = Get.find<AllGroupsController>()
        .groupDetails
        .firstWhere((group) => group.id == groupId);
  }

  void addMember() {
    _groupDetails.members.add(User(name: "New Memberrrrrrrr"));
  }

  void addExpense() {
    _groupDetails.expenses.add(Expense(title: "Expense 1", amount: 100));
  }
}
