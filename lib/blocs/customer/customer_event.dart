part of 'customer_bloc.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object> get props => [];
}

class CustomerAuthenticated extends CustomerEvent {}

class CustomerLoggedIn extends CustomerEvent {
  final Customer customer;

  const CustomerLoggedIn({required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'CustomerLoggedIn { customer: $customer }';
}

class CustomerLoggedOut extends CustomerEvent {}

class CustomerUpdated extends CustomerEvent {
  final Customer customer;

  const CustomerUpdated({required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'CustomerUpdated { customer: $customer }';

}