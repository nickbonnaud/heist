part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final Customer customer;

  Authenticated({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'Authenticated { customer: $customer }';
}

class Unauthenticated extends AuthenticationState {}

class Loading extends AuthenticationState {}