part of 'email_form_bloc.dart';

abstract class EmailFormEvent extends Equatable {
  const EmailFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends EmailFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class Submitted extends EmailFormEvent {}

class Reset extends EmailFormEvent {}
