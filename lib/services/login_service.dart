import 'package:splitit/constants/strings.dart';
import 'package:splitit/services/firebase_service.dart';

class LoginService {
  late final FirebaseService _firebaseService;

  LoginService() {
    _firebaseService = FirebaseService();
  }

  Future<void> sendOtp(String phoneNumber, Function(String) onCodeSent) async {
    return _firebaseService
        .sendOtp('${Strings.phoneNumberPrefix.trim()}${phoneNumber.trim()}', onCodeSent);
  }

  Future<void> verifyOtp(String otp, String verificationId) async {
    return _firebaseService.verifyOtp(otp, verificationId);
  }
}
