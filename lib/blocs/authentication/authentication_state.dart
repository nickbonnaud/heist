part of 'authentication_bloc.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class Unknown extends AuthenticationState {}

class Unauthenticated extends AuthenticationState{}

class Authenticated extends AuthenticationState {
  final String? errorMessage;

  const Authenticated({this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'Authenticated { errorMessage: $errorMessage }';
}