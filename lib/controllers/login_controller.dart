import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:splitit/components/edit_phone_number_dialog.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/constants/values.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';
import 'package:splitit/exceptions/send_code_exception.dart';
import 'package:splitit/pages/all_groups_page.dart';
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
  final resendSeconds = 0.obs;
  final resendCount = 0.obs;
  Timer? _timer;

  String _verificationId = '';

  final firebaseUser = Rxn<User>();

  bool get isLoggedIn => firebaseUser.value != null;
  bool get isGuest => firebaseUser.value?.isAnonymous == true;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(FirebaseAuth.instance.authStateChanges());
    _loginService = Get.find<LoginService>();
    _phoneController.addListener(_updateEnableSendOtp);
    _otpController.addListener(_updateEnableLogin);

    // Also listen to isLoading changes to update button states
    ever(isLoading, (_) {
      _updateEnableSendOtp();
      _updateEnableLogin();
    });
  }

  void _updateEnableSendOtp() {
    isEnableSendOtp.value =
        _phoneController.text.length == Values.phoneNumberLength;
  }

  void _updateEnableLogin() {
    isEnableLogin.value = _otpController.text.length == Values.otpLength;
  }

  Future<void> sendOtp() async {
    if (!isEnableSendOtp.value) return;
    isLoading.value = true;
    if (otpSent.value) {
      resendCount.value++;
      _startTimer();
    }
    try {
      await _loginService.sendOtp(
          _phoneController.text, _onCodeSent, _onVerificationFailed);
    } on SendCodeException catch (e) {
      Get.snackbar(Strings.error, e.message);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  void _onCodeSent(String verId) {
    _verificationId = verId;
    isLoading.value = false;
    if (!otpSent.value) {
      otpSent.value = true;
      _startTimer();
    }
  }

  void _onVerificationFailed(SendCodeException e) {
    isLoading.value = false;
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
      _otpController.clear();
      resendCount.value = 0;
      resendSeconds.value = 0;
      _timer?.cancel();
    }
  }

  Future<void> login() async {
    if (!isEnableLogin.value) return;
    isLoading.value = true;
    try {
      await _loginService.verifyOtp(
          _otpController.text,
          _verificationId
      );
      Get.offAllNamed(AllGroupsPage.route);
    } on InvalidCodeException catch (_) {
      Get.snackbar(Strings.error, Strings.invalidOtpMsg);
    } on Exception catch (_) {
      Get.snackbar(Strings.error, Strings.unknownErrorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInAsGuest() async {
    isLoading.value = true;
    try {
      await _loginService.signInAsGuest();
      Get.offAllNamed(AllGroupsPage.route);
    } catch (e) {
      Get.snackbar(Strings.error, Strings.unknownErrorMsg);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _phoneController.dispose();
    _otpController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void reset() {
    _phoneController.clear();
    _otpController.clear();
    isLoading.value = false;
    otpSent.value = false;
    resendSeconds.value = 0;
    resendCount.value = 0;
    _verificationId = '';
    _timer?.cancel();
  }
}
