import 'package:get/get.dart';
import 'package:splitit/constants/strings.dart';
import 'package:splitit/exceptions/send_code_exception.dart';
import 'package:splitit/services/firebase_service.dart';

class SettingsService extends GetxService {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  Future<void> updateName(String name) async {
    await _firebaseService.updateUserName(name);
  }

  Future<void> logout() async {
    await _firebaseService.signOut();
  }

  Future<void> sendOtp(String phoneNumber, Function(String) onCodeSent,
      Function(SendCodeException) onVerificationFailed) async {
    await _firebaseService.sendOtp(
        '${Strings.phoneNumberPrefix.trim()}${phoneNumber.trim()}', onCodeSent, onVerificationFailed);
  }

  Future<void> upgradeGuestAccount(String verificationId, String otp) async {
    await _firebaseService.upgradeGuestWithPhone(verificationId, otp);
  }
}
