part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class InitAuthentication extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final Customer customer;

  const LoggedIn({required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'LoggedIn { customer: $customer }';
}

class LoggedOut extends AuthenticationEvent {}
