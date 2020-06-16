part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthenticationEvent {}

class Registered extends AuthenticationEvent {
  final Customer customer;

  const Registered({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'Registered { customer: $customer }';
}

class CustomerUpdated extends AuthenticationEvent {
  final Customer customer;

  const CustomerUpdated({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'CustomerUpdated { customer: $customer }';
}

class LoggedIn extends AuthenticationEvent {}

class LoggedOut extends AuthenticationEvent {}
