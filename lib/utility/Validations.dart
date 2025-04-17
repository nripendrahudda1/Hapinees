import 'package:flutter/services.dart';

var regEx = RegExp(
    r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

String? validatePhoneCustom(String? value) {
  if (value!.trim().isEmpty) {
    return "Empty mobile number";
  } else if (value.length < 8) {
    return "Invalid mobile number";
  } else {
    return null;
  }
}

String? validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{3,3}))$';
  RegExp regExp = RegExp(pattern);
  if (value.trim().isEmpty) {
    return "Email is required";
  } else if (!regExp.hasMatch(value)) {
    return "Invalid email address";
  } else {
    return null;
  }
}

String? emailValidator(String? value) {
  if (!regEx.hasMatch(value!)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validateName(String value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value.trim().isEmpty) {
    return "Please enter this required field.";
  } else if (!regExp.hasMatch(value.trim())) {
    return "Please enter this required field.";
  } else {
    return null;
  }
}

String? validateTextField(String value) {
  return value.trim().isEmpty ? "Please enter this required field." : null;
}

bool validateName_(String value) {
  return RegExp(r'^(?=.*?[a-zA-Z ]).{3,80}$').hasMatch(value);
}

class AlphabetInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Use a regular expression to allow only alphabets
    final RegExp regExp = RegExp(r'^[a-zA-Z]*$');

    // Check if the new value matches the regular expression
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }

    // If not, return the old value
    return oldValue;
  }
}
