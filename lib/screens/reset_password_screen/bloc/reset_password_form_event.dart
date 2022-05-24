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

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PasswordConfirmationChanged extends ResetPasswordFormEvent {
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.passwordConfirmation});

  @override
  List<Object> get props => [passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation }';
}

class Submitted extends ResetPasswordFormEvent {}

class Reset extends ResetPasswordFormEvent {}
