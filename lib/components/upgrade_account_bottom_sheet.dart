import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:splitit/components/base_bottom_sheet.dart';
import 'package:splitit/components/form_button.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/controllers/settings_controller.dart';

class UpgradeAccountBottomSheet extends GetView<SettingsController> {
  const UpgradeAccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => BaseBottomSheet(
        primaryTitle: Strings.upgradeAccount,
        secondaryTitle: Strings.otp,
        showSecondary: controller.otpSent,
        primaryChildren: _primaryChildren,
        secondaryChildren: _secondaryChildren,
      ),
    );
  }

  List<Widget> get _primaryChildren => [
        TextFormField(
          controller: controller.phoneController,
          decoration: const InputDecoration(
            labelText: Strings.phoneNumber,
            prefixText: Strings.phoneNumberPrefix,
            prefixIcon: Icon(Icons.phone),
            hintText: Strings.phoneNumberHint,
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(Values.phoneNumberLength),
          ],
        ),
        const SizedBox(height: Values.defaultVerticalGap),
        FormButton(
          onPressed: controller.sendUpgradeOtp,
          text: Strings.sendOtp,
          enabled: controller.isEnableSendOtp.value,
          isLoading: controller.isUpgrading.value,
        ),
      ];

  List<Widget> get _secondaryChildren => [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${Strings.phoneNumberPrefix}${controller.phoneController.text}",
              style: Get.textTheme.titleMedium
                  ?.copyWith(color: Get.theme.hintColor),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              onPressed: controller.editNumber,
              icon: const Icon(
                Icons.edit,
                size: Values.defaultTextSize,
              ),
            )
          ],
        ),
        const SizedBox(height: Values.defaultHorizontalGap * 2),
        Pinput(
          controller: controller.otpController,
          length: Values.otpLength,
          keyboardType: TextInputType.number,
          onCompleted: (_) => controller.verifyOtpAndUpgrade(),
        ),
        if (controller.resendCount.value < Values.resendTimings.length)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: (controller.isUpgrading.value ||
                      controller.resendSeconds.value > 0)
                  ? null
                  : controller.sendUpgradeOtp,
              child: Text(
                controller.resendSeconds.value > 0
                    ? "${Strings.resendOtp} (${controller.resendSeconds.value}s)"
                    : Strings.resendOtp,
              ),
            ),
          ),
        const SizedBox(height: Values.defaultVerticalGap),
        FormButton(
          onPressed: controller.verifyOtpAndUpgrade,
          text: Strings.upgradeAccount,
          enabled: controller.isEnableUpgrade.value,
          isLoading: controller.isUpgrading.value,
        ),
      ];
}
