part of 'request_reset_form_bloc.dart';

abstract class RequestResetFormEvent extends Equatable {
  const RequestResetFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends RequestResetFormEvent {
  final String email;

  const EmailChanged({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class Submitted extends RequestResetFormEvent {
  final String email;

  const Submitted({required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'Submitted { email: $email }';
}

class Reset extends RequestResetFormEvent {}