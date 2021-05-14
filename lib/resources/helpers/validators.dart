class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  
  static final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[0-9])(?=.*[A-Za-z])(?=.*[~!?@#$%^&*_-])[A-Za-z0-9~!?@#$%^&*_-]{6,40}$'
  );

  static final RegExp _nameRegExp = RegExp(
    r'^[a-zA-Z]([\w -]*[a-zA-Z])?$'
  );

  static final RegExp _tipRegExp = RegExp(
    r'^([0-9]?\d|30)$'
  );

  static isValidEmail(String email) => _emailRegExp.hasMatch(email);

  static isValidPassword(String password) => _passwordRegExp.hasMatch(password);

  static isPasswordConfirmationValid(String password, String passwordConfirmation) => password == passwordConfirmation;

  static isValidName(String name) => _nameRegExp.hasMatch(name);

  static isValidTip(int tip) => _tipRegExp.hasMatch(tip.toString());
}