import 'package:validators/validators.dart';

class Validators {

  static bool isValidEmail({required String email}) => isEmail(email);

  static bool isValidPassword({required String password}) {
    if (password.isEmpty) return false;

    final bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacters = password.contains(RegExp(r'[-!@#$%^&*_+=(),.?":{}|<>]'));
    final bool hasMinLength = password.trim().length >= 8;

    return hasUpperCase && hasLowerCase && hasDigits && hasSpecialCharacters && hasMinLength;
  }

  static bool isPasswordConfirmationValid({required String password, required String passwordConfirmation}) => password == passwordConfirmation;

  static bool isValidName({required String name}) {
    if (name.isEmpty) return false;

    final bool hasNoDigits = !name.contains(RegExp(r'[0-9]'));
    final bool hasNoSpecialCharacters = !name.contains(RegExp(r'[\(\)\[\]\{\}\*\+\?\^\$\|\\~`!@#%&_=;:",<>/]'));
    final bool hasMinLength = name.length >= 2;

    return hasNoDigits && hasNoSpecialCharacters && hasMinLength;
  }

  static bool isValidDefaultTip({required String tip}) {
    final bool isDigits = isNumeric(tip);
    if (!isDigits) return false;

    final int? intTip = int.tryParse(tip);
    if (intTip == null) return false;
    
    final bool meetsMinValue = intTip >= 0;
    final bool meetsMaxValue = intTip <= 30;

    return meetsMaxValue && meetsMinValue;
  }

  static bool isValidQuickTip({required String tip}) {
    final bool isDigits = isNumeric(tip);
    if (!isDigits) return false;

    final int? intTip = int.tryParse(tip);
    if (intTip == null) return false;
    
    final bool meetsMinValue = intTip >= 0;
    final bool meetsMaxValue = intTip <= 20;

    return meetsMaxValue && meetsMinValue;
  }

  static bool isValidResetCode({required String resetCode}) {
    if (resetCode.isEmpty) return false;

    final bool isCorrectLength = resetCode.trim().length == 6;
    final bool isAlphaNumeric = isAlphanumeric(resetCode);

    return isCorrectLength && isAlphaNumeric;
  }

  static bool isValidUUID({required String uuid}) => isUUID(uuid);
}