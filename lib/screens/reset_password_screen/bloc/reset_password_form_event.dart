part of 'reset_password_form_bloc.dart';

abstract class ResetPasswordFormEvent extends Equatable {
  const ResetPasswordFormEvent();

  @override
  List<Object> get props => [];
}

class ResetCodeChanged extends ResetPasswordFormEvent {
  final String resetCode;

  const ResetCodeChanged({required this.resetCode});

  @override
  List<Object> get props => [resetCode];

  @override
  String toString() => 'ResetCodeChanged { resetCode: $resetCode }';
}

class PasswordChanged extends ResetPasswordFormEvent {
  final String password;
  final String passwordConfirmation;

  const PasswordChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class PasswordConfirmationChanged extends ResetPasswordFormEvent {
  final String passwordConfirmation;
  final String password;

  const PasswordConfirmationChanged({required this.passwordConfirmation, required this.password});

  @override
  List<Object> get props => [passwordConfirmation, password];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation, password: $password }';
}

class Submitted extends ResetPasswordFormEvent {
  final String resetCode;
  final String passwordConfirmation;
  final String password;

  const Submitted({required this.resetCode, required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [resetCode, password, passwordConfirmation];

  @override
  String toString() => 'Submitted { resetCode: $resetCode, password: $password, passwordConfirmation: $passwordConfirmation }';
}

class Reset extends ResetPasswordFormEvent {}
