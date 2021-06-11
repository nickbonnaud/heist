part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class PasswordChanged extends RegisterEvent {
  final String password;
  final String passwordConfirmation;

  const PasswordChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class PasswordConfirmationChanged extends RegisterEvent {
  final String passwordConfirmation;
  final String password;

  const PasswordConfirmationChanged({required this.passwordConfirmation, required this.password});

  @override
  List<Object> get props => [passwordConfirmation, password];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation, password: $password }';
}

class Submitted extends RegisterEvent {
  final String email;
  final String password;
  final String passwordConfirmation;

  Submitted({required this.email, required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [email, password, passwordConfirmation];
  
  @override
  String toString() => '''Submitted {
    email: $email,
    password: $password,
    passwordConfirmation: $passwordConfirmation 
  }''';
}
