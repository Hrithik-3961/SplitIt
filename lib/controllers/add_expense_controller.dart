import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/models/user.dart';
import 'package:splitit/services/add_expense_service.dart';

class AddExpenseController extends GetxController {

  late AddExpenseService _addExpenseService;
  List<String> get splitOptions => Strings.splitOptions;
  List<User> get members => _addExpenseService.members;

  final splitOption = Strings.splitOptions.first.obs;

  @override
  void onInit() {
    super.onInit();
    _addExpenseService = Get.put(AddExpenseService());
  }

}

class AddExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddExpenseController());
  }

}