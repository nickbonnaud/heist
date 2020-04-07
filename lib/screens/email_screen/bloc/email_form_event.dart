part of 'email_form_bloc.dart';

abstract class EmailFormEvent extends Equatable {
  const EmailFormEvent();

  @override
  List<Object> get props => [];
}

class EmailChanged extends EmailFormEvent {
  final String email;

  const EmailChanged({@required this.email});

  @override
  List<Object> get props => [email];

  @override
  String toString() => 'EmailChanged { email: $email }';
}

class Submitted extends EmailFormEvent {
  final String email;
  final Customer customer;

  const Submitted({@required this.email, @required this.customer});

  @override
  List<Object> get props => [email, customer];

  @override
  String toString() => 'Submitted { email: $email, customer: $customer }';
}

class Reset extends EmailFormEvent {}
