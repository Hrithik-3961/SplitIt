import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:splitit/components/confirmation_dialog.dart';
import 'package:splitit/components/upgrade_account_bottom_sheet.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/exceptions/send_code_exception.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/services/settings_service.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  late final SettingsService _settingsService;

  final Rx<MyUser> user = Get.find<MyUser>().obs;
  final RxBool isEditingName = false.obs;
  final RxString version = "".obs;

  final TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> nameFormKey = GlobalKey<FormState>();

  // Upgrade related
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final RxBool otpSent = false.obs;
  final RxBool isEnableSendOtp = false.obs;
  final RxBool isEnableUpgrade = false.obs;
  final RxBool isUpgrading = false.obs;
  final RxInt resendSeconds = 0.obs;
  final RxInt resendCount = 0.obs;
  Timer? _timer;
  String _verificationId = '';

  @override
  void onInit() {
    super.onInit();
    _settingsService = Get.put(SettingsService());
    nameController.text = user.value.name;
    _fetchVersion();

    phoneController.addListener(() {
      isEnableSendOtp.value =
          phoneController.text.length == Values.phoneNumberLength;
    });
    otpController.addListener(() {
      isEnableUpgrade.value = otpController.text.length == Values.otpLength;
    });

    // Update local observable if MyUser changes in Get
    ever(user, (_) {
      if (!isEditingName.value) {
        nameController.text = user.value.name;
      }
    });
  }

  void _fetchVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void toggleEditName() {
    if (isEditingName.value) {
      // If canceling, reset name
      nameController.text = user.value.name;
    }
    isEditingName.value = !isEditingName.value;
  }

  void onUpdateName() async {
    if (!(nameFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final newName = nameController.text.trim();
    if (newName == user.value.name) {
      isEditingName.value = false;
      return;
    }

    try {
      await _settingsService.updateName(newName);
      user.value = Get.find<MyUser>();
      isEditingName.value = false;
      Get.snackbar("Success", "Name updated successfully");
    } catch (e) {
      Get.snackbar(Strings.error, e.toString());
    }
  }

  void sendUpgradeOtp() async {
    if (!isEnableSendOtp.value) return;
    isUpgrading.value = true;
    if (otpSent.value) {
      resendCount.value++;
      _startTimer();
    }
    try {
      await _settingsService.sendOtp(
          phoneController.text, _onCodeSent, _onVerificationFailed);
    } catch (e) {
      Get.snackbar(Strings.error, e.toString());
      isUpgrading.value = false;
    }
  }

  void _onCodeSent(String verId) {
    _verificationId = verId;
    isUpgrading.value = false;
    if (!otpSent.value) {
      otpSent.value = true;
      _startTimer();
    }
  }

  void _onVerificationFailed(SendCodeException e) {
    isUpgrading.value = false;
    Get.snackbar(Strings.error, e.message);
  }

  void _startTimer() {
    int seconds = 0;
    if (resendCount.value < Values.resendTimings.length) {
      seconds = Values.resendTimings[resendCount.value];
    }

    if (seconds > 0) {
      resendSeconds.value = seconds;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (resendSeconds.value > 0) {
          resendSeconds.value--;
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void verifyOtpAndUpgrade() async {
    isUpgrading.value = true;
    try {
      await _settingsService.upgradeGuestAccount(
          _verificationId, otpController.text);
      user.value = Get.find<MyUser>();
      Get.back(); // Close bottom sheet
      Get.snackbar("Success", "Account upgraded successfully!");
    } catch (e) {
      Get.snackbar(Strings.error, e.toString());
    } finally {
      isUpgrading.value = false;
    }
  }

  void resetUpgradeState() {
    otpSent.value = false;
    phoneController.clear();
    otpController.clear();
    _verificationId = '';
    resendCount.value = 0;
    resendSeconds.value = 0;
    _timer?.cancel();
  }

  void editNumber() async {
    final result = await Get.dialog(
      ConfirmationDialog(
          title: Strings.editPhoneNumber,
          content:
              "${Strings.editNumberMsg}\n${Strings.phoneNumberPrefix}${phoneController.text} ?",
          confirmText: Strings.yes,
          onConfirmed: () {
            Get.back(result: true);
          }),
    );
    if (result != null) {
      otpSent.value = false;
      otpController.clear();
      resendCount.value = 0;
      resendSeconds.value = 0;
      _timer?.cancel();
    }
  }

  void showUpgradeAccountBottomSheet() {
    resetUpgradeState();
    Get.bottomSheet(
      const UpgradeAccountBottomSheet(),
      isScrollControlled: true,
    );
  }

  void logout() {
    Get.dialog(
      ConfirmationDialog(
        title: Strings.logout,
        content: Strings.logoutConfirmMsg,
        confirmText: Strings.logout,
        onConfirmed: () {
          Get.back();
          _settingsService.logout();
        },
      ),
    );
  }

  void deleteAccount() {
    Get.dialog(
      ConfirmationDialog(
        title: Strings.deleteAccount,
        content: Strings.deleteAccountConfirmMsg,
        confirmText: Strings.delete,
        onConfirmed: () {
          Get.back();
          _settingsService.deleteAccount();
        },
      ),
    );
  }

  void openPrivacyPolicy() async {
    final Uri url = Uri.parse(Strings.privacyPolicyUrl);
    if (!await launchUrl(url)) {
      Get.snackbar(Strings.error, Strings.privacyUrlErrorMsg);
    }
  }

  void openDataDeletion() async {
    final Uri url = Uri.parse(Strings.dataDeletionUrl);
    if (!await launchUrl(url)) {
      Get.snackbar(Strings.error, Strings.privacyUrlErrorMsg);
    }
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController());
  }
}
