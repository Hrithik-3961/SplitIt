import 'package:flutter/material.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:get/get.dart';
import 'package:splitit/controllers/settings_controller.dart';

class UpgradeAccountCard extends GetView<SettingsController> {
  const UpgradeAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Values.defaultVerticalGap),
      child: Card(
        color: Get.theme.primaryColor.withValues(alpha: 0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Values.borderRadius),
          side: BorderSide(color: Get.theme.primaryColor),
        ),
        child: Padding(
          padding: Values.defaultPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Get.theme.primaryColor),
                  const SizedBox(width: Values.defaultHorizontalGap),
                  Expanded(
                    child: Text(
                      Strings.upgradeAccountMsg,
                      style: TextStyle(color: Get.theme.primaryColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Values.defaultHorizontalGap * 2),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.showUpgradeAccountBottomSheet,
                  child: const Text(Strings.upgradeAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
