class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static bool isValidEmail({required String email}) => _emailRegExp.hasMatch(email);

  static bool isValidPassword({required String password}) {
    if (password.isEmpty) return false;

    final bool hasUpperCase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowerCase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigits = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialCharacters = password.contains(RegExp(r'[-!@#$%^&*_+=(),.?":{}|<>]'));
    final bool hasMinLength = password.length >= 8;

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

  static bool isValidTip({required int tip}) => tip is int;
}