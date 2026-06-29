import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/exceptions/send_code_exception.dart';
import 'package:splitit/services/firebase_service.dart';

class LoginService {
  late final FirebaseService _firebaseService;

  LoginService() {
    _firebaseService = Get.find<FirebaseService>();
  }

  Future<void> sendOtp(String phoneNumber, Function(String) onCodeSent) async {
    try {
      await _firebaseService
          .sendOtp('${Strings.phoneNumberPrefix.trim()}${phoneNumber.trim()}',
          onCodeSent);
    } on SendCodeException catch (_) {
      rethrow;
    }
  }

  Future<void> verifyOtp(String otp, String verificationId) async {
    return _firebaseService.verifyOtp(otp, verificationId);
  }

  Future<void> signInAsGuest() async {
    return _firebaseService.signInAsGuest();
  }
}
