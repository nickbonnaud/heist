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
  final String passwordConfirmation;

  const PasswordChanged({required this.password, required this.passwordConfirmation});

  @override
  List<Object> get props => [password, passwordConfirmation];

  @override
  String toString() => 'PasswordChanged { password: $password, passwordConfirmation: $passwordConfirmation }';
}

class PasswordConfirmationChanged extends PasswordFormEvent {
  final String passwordConfirmation;
  final String password;

  const PasswordConfirmationChanged({required this.passwordConfirmation, required this.password});

  @override
  List<Object> get props => [passwordConfirmation, password];

  @override
  String toString() => 'PasswordConfirmationChanged { passwordConfirmation: $passwordConfirmation, password: $password }';
}

class OldPasswordSubmitted extends PasswordFormEvent {
  final String oldPassword;

  const OldPasswordSubmitted({required this.oldPassword});

  @override
  List<Object> get props => [oldPassword];

  @override
  String toString() => 'OldPasswordSubmitted { oldPassword: $oldPassword }';
}

class NewPasswordSubmitted extends PasswordFormEvent {
  final String oldPassword;
  final String password;
  final String passwordConfirmation;
  final String customerIdentifier;

  const NewPasswordSubmitted({required this.oldPassword, required this.password, required this.passwordConfirmation, required this.customerIdentifier});

  @override
  List<Object> get props => [oldPassword, password, passwordConfirmation, customerIdentifier];

  @override
  String toString() => 'NewPasswordSubmitted { oldPassword: $oldPassword, password: $password, passwordConfirmation: $passwordConfirmation, customerIdentifier: $customerIdentifier }';
}

class Reset extends PasswordFormEvent {}