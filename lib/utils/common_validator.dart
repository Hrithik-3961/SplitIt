import 'package:splitit/constants/strings.dart';

class CommonValidator {

  static String? validateName(String? name) {

    if (name == null || name.isEmpty) {
      return Strings.enterValidName;
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