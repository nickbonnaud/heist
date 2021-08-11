part of 'sign_out_bloc.dart';

abstract class SignOutEvent extends Equatable {
  const SignOutEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends SignOutEvent {}

class Reset extends SignOutEvent {}
