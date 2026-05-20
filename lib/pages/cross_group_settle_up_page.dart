import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/settle_up_item.dart';
import 'package:splitit/components/settle_up_layout.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/cross_group_settle_up_controller.dart';
import 'package:splitit/utils/base_util.dart';

class CrossGroupSettleUpPage extends GetView<CrossGroupSettleUpController> {
  const CrossGroupSettleUpPage({super.key});

  static const String route = "/crossGroupSettleUp";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SettleUpLayout(
        title: Strings.crossGroupSettleUp,
        isLoading: controller.isLoading.value,
        isEmpty: controller.suggestions.isEmpty,
        itemCount: controller.suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = controller.suggestions[index];
          return SettleUpItem(
            suggestion: suggestion,
            onSettle: () => controller.settle(suggestion),
            children: suggestion.groupBreakdown.entries
                .where((e) => e.value.amount.abs() > 0.01)
                .map((e) {
              final breakdown = e.value;
              return ExpansionTile(
                backgroundColor: Colors.grey.withValues(alpha: 0.1),
                collapsedBackgroundColor: Colors.grey.withValues(alpha: 0.05),
                title: Text("${Strings.group}: ${breakdown.groupName}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(BaseUtil.getFormattedCurrency(
                        breakdown.amount.abs().toStringAsFixed(2))),
                    const Icon(Icons.expand_more, size: Values.smallIconSize),
                  ],
                ),
                children: breakdown.transitivePayments
                    .map((tp) => ListTile(
                          dense: true,
                          contentPadding: Values.largeContentPadding,
                          title: Row(
                            children: [
                              Text(tp.fromName,
                                  style: const TextStyle(
                                      fontSize: Values.smallTextSize)),
                              const Icon(Icons.arrow_right,
                                  size: Values.extraSmallIconSize),
                              Text(tp.toName,
                                  style: const TextStyle(
                                      fontSize: Values.smallTextSize)),
                            ],
                          ),
                          trailing: Text(
                            BaseUtil.getFormattedCurrency(
                                tp.amount.toStringAsFixed(2)),
                            style: const TextStyle(
                                fontSize: Values.smallTextSize,
                                color: Colors.grey),
                          ),
                        ))
                    .toList(),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
