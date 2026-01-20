import 'package:get/get.dart';
import '../controllers/group_overview_controller.dart';
import '../models/user.dart';

class RecordPaymentService {
  late List<User> _members;

  List<User> get members => _members;

  RecordPaymentService() {
    _init();
  }

  void _init() {
    _members = Get.find<GroupOverviewController>().members;
  }

  void savePayment({required User paidFrom, required User paidTo, required double amount}) {
    paidFrom.subtractAmountOwed(amount);
    paidTo.addAmountOwed(amount);
  }
}