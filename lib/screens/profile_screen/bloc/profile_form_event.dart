part of 'profile_form_bloc.dart';

abstract class ProfileFormEvent extends Equatable {
  const ProfileFormEvent();

  @override
  List<Object> get props => [];
}

class FirstNameChanged extends ProfileFormEvent {
  final String firstName;

  const FirstNameChanged({@required this.firstName});

  @override
  List<Object> get props => [firstName];

  @override
  String toString() => 'FirstNameChanged { firstName: $firstName }';
}

class LastNameChanged extends ProfileFormEvent {
  final String lastName;

  const LastNameChanged({@required this.lastName});

  @override
  List<Object> get props => [lastName];

  @override
  String toString() => 'LastNameChanged { firstName: $lastName }';
}

class Submitted extends ProfileFormEvent {
  final String firstName;
  final String lastName;
  final Customer customer;

  const Submitted({@required this.firstName, @required this.lastName, @required this.customer});

  @override
  List<Object> get props => [firstName, lastName, customer];

  @override
  String toString() => 'Submitted { firstName: $firstName, lastName: $lastName, customer: $customer }';
}
