import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/edit_phone_number_dialog.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/services/login_service.dart';

class LoginController extends GetxController {
  late final LoginService _loginService;

  get formKey => _formKey;

  get phoneController => _phoneController;

  get otpController => _otpController;

  get phoneKey => _phoneKey;

  get otpKey => _otpKey;

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _phoneKey = const ValueKey(Strings.phoneNumber);
  final _otpKey = const ValueKey(Strings.otp);

  final isEnableSendOtp = false.obs;
  final isEnableLogin = false.obs;
  final isLoading = false.obs;
  final otpSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loginService = Get.put(LoginService());
    _phoneController.addListener(() {
      isEnableSendOtp.value =
          _phoneController.text.length == Values.phoneNumberLength;
    });
    _otpController.addListener(() {
      isEnableLogin.value = _otpController.text.length == Values.otpLength;
    });
  }

  Future<void> sendOtp() async {
    if (_phoneController.text.length != Values.phoneNumberLength) {
      Get.snackbar('Error', 'Please enter a valid 10-digit phone number');
      return;
    }
    isLoading.value = true;
    await _loginService.sendOtp(_phoneController.text);
    isLoading.value = false;
    otpSent.value = true;
    Get.snackbar('Success', 'OTP sent to ${_phoneController.text}');
  }

  void editNumber() async {
    final result = await Get.dialog(
      EditPhoneNumberDialog(
        text:
            "${Strings.editNumberMsg}\n${Strings.phoneNumberPrefix}${_phoneController.text} ?",
        onPositiveBtnPressed: () {
          Get.back(result: true);
        },
      ),
    );
    if (result != null) {
      otpSent.value = false;
    }
  }

  Future<void> login() async {
    if (_otpController.text.length < 4) {
      Get.snackbar('Error', 'Please enter a valid OTP');
      return;
    }
    isLoading.value = true;
    final success = await _loginService.verifyOtp(
      _phoneController.text,
      _otpController.text,
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar('Success', 'Login successful!');
    } else {
      Get.snackbar('Error', 'Invalid OTP. Please try again.');
    }
  }

  @override
  void onClose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.onClose();
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}
