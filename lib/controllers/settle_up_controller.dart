import 'package:get/get.dart';
import 'package:splitit/controllers/group_overview_controller.dart';
import 'package:splitit/models/suggested_payment.dart';
import 'package:splitit/services/settle_up_service.dart';

class SettleUpController extends GetxController {
  final RxList<SuggestedPayment> suggestions = <SuggestedPayment>[].obs;
  late final SettleUpService _settleUpService;
  late final GroupOverviewController _groupOverviewController;

  @override
  void onInit() {
    super.onInit();
    _settleUpService = SettleUpService();
    _groupOverviewController = Get.find<GroupOverviewController>();
    
    _calculateSuggestions();
    
    // Refresh suggestions if members change
    ever(_groupOverviewController.members, (_) => _calculateSuggestions());
  }

  void _calculateSuggestions() {
    suggestions.assignAll(_settleUpService.getSuggestions());
  }

  void settle(SuggestedPayment suggestion) {
    final transaction = _settleUpService.createSettleTransaction(suggestion);
    Get.back(result: transaction);
  }
}

class SettleUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettleUpController());
  }
}
