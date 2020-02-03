import 'package:arezue/utils/texts.dart';

enum FormType { login, register, reset}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ArezueTexts.emailError;
    } else if (!value.contains('@')) {
      return ArezueTexts.emailValidError;
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return ArezueTexts.passwordError;
    } else if (value.length <= 8) {
      return ArezueTexts.passwordShort;
    }
    return null;
  }
}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    return null;
  }
}
