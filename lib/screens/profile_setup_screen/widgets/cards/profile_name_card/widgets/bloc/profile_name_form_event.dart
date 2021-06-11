part of 'profile_name_form_bloc.dart';

abstract class ProfileNameFormEvent extends Equatable {
  const ProfileNameFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends ProfileNameFormEvent {
  final String firstName;

  const FirstNameChanged({required this.firstName});

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName: $firstName }';
}

class LastNameChanged extends ProfileNameFormEvent {
  final String lastName;

  const LastNameChanged({required this.lastName});

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { firstName: $lastName }';
}

class Submitted extends ProfileNameFormEvent {
  final String firstName;
  final String lastName;

  const Submitted({required this.firstName, required this.lastName});

  @override
  List<Object> get props => [firstName, lastName];

  @override
  String toString() => 'Submitted { firstName: $firstName, lastName: $lastName }';
}

class Reset extends ProfileNameFormEvent {}

