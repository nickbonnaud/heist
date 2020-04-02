part of 'customer_bloc.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

class SignedOut extends CustomerState {}

class SignedIn extends CustomerState {
  final Customer customer;

  SignedIn({@required this.customer});

  @override
  List<Object> get props => [customer];

  @override
  String toString() => 'SignedIn {customer: $customer }';
}