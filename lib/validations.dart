import 'package:arezue/utils/texts.dart';

enum FormType { login, register, reset }

class EmailValidator {
  static String validate(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
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

class NumberValidator {
  static String validate(String value) {
    RegExp float =
        RegExp(r'^(?:-?(?:[0-9]+))?(?:\.[0-9]*)?(?:[eE][\+\-]?(?:[0-9]+))?$');
    if (!(float.hasMatch(value))) {
      return 'Enter a valid wage';
    }
    return null;
  }
}
