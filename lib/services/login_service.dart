import 'dart:developer';

class LoginService {
  LoginService();

  Future<void> sendOtp(String phoneNumber) async {
    // In a real app, this would involve a backend service to send an OTP.
    // For now, we'll just simulate a delay.
    log('Sending OTP to $phoneNumber');
    await Future.delayed(const Duration(seconds: 2));
    log('OTP sent!');
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    // In a real app, this would involve a backend service to verify the OTP.
    // For now, we'll just simulate a delay and a successful verification.
    log('Verifying OTP $otp for $phoneNumber');
    await Future.delayed(const Duration(seconds: 2));
    log('OTP verified!');
    return true;
  }
}
