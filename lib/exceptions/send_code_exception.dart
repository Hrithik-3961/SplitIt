class SendCodeException implements Exception {
  final String message;
  SendCodeException({this.message = 'Failed to send verification code.'});
}