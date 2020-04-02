class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$'
  );

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]([\w -]*[a-zA-Z])?$'
  );

  static isValidEmail(String email) => _emailRegExp.hasMatch(email);

  static isValidPassword(String password) => _passwordRegExp.hasMatch(password);

  static isPasswordConfirmationValid(String password, String passwordConfirmation) => password == passwordConfirmation;

  static isValidName(String name) => _nameRegExp.hasMatch(name);
}