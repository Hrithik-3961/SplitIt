import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/styles.dart';

import '../components/form_button.dart';
import '../constants/values.dart';
import '../controllers/login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  static const String route = "/login";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Values.loginPagePadding,
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.welcome,
                    style: Get.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Values.defaultHorizontalGap),
                  Text(
                    Strings.loginMsg,
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Get.theme.hintColor,
                    ),
                  ),
                  const SizedBox(height: 2 * Values.defaultVerticalGap),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: Values.defaultAnimationDuration,
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeInBack,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                      child: !controller.otpSent.value
                          ? Column(
                              key: controller.phoneKey,
                              children: [
                                TextFormField(
                                  controller: controller.phoneController,
                                  decoration: Styles.phoneNumberInputDecoration,
                                  inputFormatters:
                                      Styles.phoneNumberInputFormatters,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(
                                    height: Values.defaultHorizontalGap),
                                FormButton(
                                  onPressed: controller.sendOtp,
                                  text: Strings.sendOtp,
                                  enabled: controller.isEnableSendOtp.value,
                                ),
                              ],
                            )
                          : Column(
                              key: controller.otpKey,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  Strings.otpText,
                                  style: Get.textTheme.titleMedium,
                                ),
                                const SizedBox(
                                    height: Values.defaultHorizontalGap),
                                Row(
                                  children: [
                                    Text(
                                      "${Strings.phoneNumberPrefix}${controller.phoneController.text}",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.hintColor),
                                    ),
                                    IconButton(visualDensity: VisualDensity.compact,
                                      onPressed: controller.editNumber,
                                      icon: const Icon(
                                        Icons.edit,
                                        size: Values.defaultTextSize,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                    height: Values.defaultHorizontalGap),
                                Pinput(
                                  controller: controller.otpController,
                                  length: Values.otpLength,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: Styles.otpInputFormatters,
                                ),
                                const SizedBox(
                                    height: Values.defaultVerticalGap),
                                FormButton(
                                  onPressed: controller.login,
                                  text: Strings.login,
                                  enabled: controller.isEnableLogin.value,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
