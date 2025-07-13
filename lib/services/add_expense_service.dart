import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/group_overview_controller.dart';

import 'package:splitit/models/user.dart';

class AddExpenseService {
  late List<User> _members;

  List<User> get members => _members;
  List<String> get splitOptions => Strings.splitOptions;

  AddExpenseService() {
    _init();
  }

  void _init() {
    _members = Get.find<GroupOverviewController>().members;
  }

}