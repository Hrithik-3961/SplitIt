import 'package:splitit/constants/strings.dart';

class CommonValidator {

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return Strings.enterValidName;
    }
    if (name.trim().length < 2) {
      return Strings.lessCharacterMsg;
    }
    if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(name.trim())) {
      return Strings.invalidCharactersMsg;
    }
    return null;
  }

  static String? validatePhoneNumber(String? phoneNumber) {

    if (phoneNumber == null || phoneNumber.isEmpty || phoneNumber.length < 10) {
      return Strings.enterValidPhoneNumber;
    }

    return null;
  }

}