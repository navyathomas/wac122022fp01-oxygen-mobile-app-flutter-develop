import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oxygen/common/constants.dart';
import 'package:oxygen/common/extensions.dart';

enum InputFormatType { name, phoneNumber, email, password }

class Validator {
  Validator.__();

  static String? validateMobile(String? value, {int? maxLength, String? msg}) {
    String pattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
    RegExp regExp = RegExp(pattern);
    if (msg != null) return msg;
    if ((value ?? '').isEmpty) return Constants.emptyStringMsg;
    if (!regExp.hasMatch(value!) ||
        (maxLength != null && value.length != maxLength)) {
      return Constants.enterValidNumberMsg;
    }
    return null;
  }

  static bool validateIsMobileNumber(String value) {
    String pattern = r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateMobileNoLimit(BuildContext context, String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{8,13}$)';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value) || value.isEmpty) {
      return Constants.enterValidNumberMsg;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value.length < 3) {
      return Constants.nameValidatorMsg(3);
    }
    return null;
  }

  static String? validateOtp(String? value, {String? msg}) {
    if (msg.notEmpty) return msg;
    if (value == null || value.isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value.length < 4) {
      return Constants.invalidOtp;
    }
    return null;
  }

  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value.contains(RegExp(r'[0-9]')) ||
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Please enter a valid last name';
    }
    return null;
  }

  static String? validateText(BuildContext context, String value) {
    return (value.trim().isEmpty) ? Constants.emptyStringMsg : null;
  }

  static String? validateInvalidateOtp(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value.length != 6) {
      return Constants.invalidOtp;
    }
    return null;
  }

  static String? validatePassword(String? value, {String? msg}) {
    String errorMsg = Constants.passwordValidationMsg;
    if ((msg ?? '').isNotEmpty) {
      return msg;
    } else if ((value ?? '').isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value!.length < 8) {
      return errorMsg;
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return errorMsg;
    } else if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return errorMsg;
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return errorMsg;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if ((value ?? '').isEmpty) {
      return Constants.emptyStringMsg;
    } else if (value != newPassword) {
      return Constants.passwordNotEquel;
    }
    return null;
  }

  static bool validateIsEmail(String value) {
    const pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  static String? validateEmail(String? value, {String? msg}) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (msg != null) return msg;
    if ((value ?? '').isEmpty) return Constants.emptyStringMsg;
    if (!regex.hasMatch(value!)) {
      return Constants.emailValidationMsg;
    } else {
      return null;
    }
  }

  static String? validateCurrentPassword(String value) {
    if (value.trim().isEmpty) {
      return 'Enter current password';
    } else {
      return null;
    }
  }

  static List<TextInputFormatter>? inputFormatter(InputFormatType type) {
    List<TextInputFormatter>? val;
    switch (type) {
      case InputFormatType.phoneNumber:
        val = [
          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
        ];
        break;

      case InputFormatType.password:
        val = [
          FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z@]")),
        ];
        break;
      case InputFormatType.name:
        val = [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))];
        break;
      case InputFormatType.email:
        val = [FilteringTextInputFormatter.deny(RegExp(r'[- /+?:;*#$%^&*()]'))];
        break;
    }
    return val;
  }
}
