part of 'password_form_bloc.dart';

abstract class PasswordFormEvent extends Equatable {
  const PasswordFormEvent();
  
  @override
  List<Object> get props => [];
}

class OldPasswordChanged extends PasswordFormEvent {
  final String oldPassword;

  const OldPasswordChanged({required this.oldPassword});

  @override
  List<Object> get props => [oldPassword];

  @override
  String toString() => 'OldPasswordChanged { oldPassword: $oldPassword }';
}

class PasswordChanged extends PasswordFormEvent {
  final String password;

  const PasswordChanged({required this.password});

  @override
  List<Object> get props => [password];

  @override
  String toString() => 'PasswordChanged { password: $password }';
}

class PasswordConfirmationChanged extends PasswordFormEvent {
  final String passwordConfirmation;

  const PasswordConfirmationChanged({required this.passwordConfirmation});

  @override
  List<Object> get props => [passwordConfirmation];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation }';
}

class OldPasswordSubmitted extends PasswordFormEvent {}

class NewPasswordSubmitted extends PasswordFormEvent {}

class Reset extends PasswordFormEvent {}