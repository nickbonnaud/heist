part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class SignIn extends CustomerEvent {
  final Customer customer;

  SignIn({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'SignIn { customer: $customer }';
}

class UpdateCustomer extends CustomerEvent {
  final Customer customer;

  UpdateCustomer({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'UpdateCustomer { customer: $customer }';
}

class SignOut extends CustomerEvent {}
