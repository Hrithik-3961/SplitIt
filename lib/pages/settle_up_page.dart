import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/settle_up_item.dart';
import 'package:splitit/components/settle_up_layout.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/controllers/settle_up_controller.dart';

class SettleUpPage extends GetView<SettleUpController> {
  const SettleUpPage({super.key});

  static const String route = "/settleUp";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SettleUpLayout(
        title: Strings.settleUp,
        isEmpty: controller.suggestions.isEmpty,
        itemCount: controller.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = controller.suggestions[index];
          return SettleUpItem(
            suggestion: suggestion,
            onSettle: () => controller.settle(suggestion),
          );
        },
      ),
    );
  }
}
