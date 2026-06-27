import 'package:get/get.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/models/cross_group_suggestion.dart';
import 'package:splitit/services/cross_group_settle_up_service.dart';

class CrossGroupSettleUpController extends GetxController {
  final RxList<CrossGroupSuggestion> suggestions = <CrossGroupSuggestion>[].obs;
  final RxBool isLoading = true.obs;
  
  late final CrossGroupSettleUpService _settleUpService;

  @override
  void onInit() {
    super.onInit();
    _settleUpService = Get.put(CrossGroupSettleUpService());
    _loadAllBalances();
  }

  Future<void> _loadAllBalances() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _settleUpService.fetchCrossGroupSuggestions(),
        Future.delayed(Values.defaultAnimationDuration),
      ]);
      suggestions.assignAll(results[0] as List<CrossGroupSuggestion>);
    } finally {
      isLoading.value = false;
    }
  }

  void settle(CrossGroupSuggestion suggestion) async {
    await _settleUpService.settleCrossGroupSuggestion(suggestion);
    _loadAllBalances();
  }
}

class CrossGroupSettleUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CrossGroupSettleUpController());
  }
}
