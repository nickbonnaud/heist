part of 'transaction_picker_screen_bloc.dart';

abstract class TransactionPickerScreenEvent extends Equatable {
  const TransactionPickerScreenEvent();

  @override
  List<Object> get props => [];
}

class Fetch extends TransactionPickerScreenEvent {
  final String businessIdentifier;

  const Fetch({required this.businessIdentifier});

  @override
  List<Object> get props => [businessIdentifier];

  @override
  String toString() => 'Fetch { businessIdentifier: $businessIdentifier }';
}

class Claim extends TransactionPickerScreenEvent {
  final UnassignedTransactionResource unassignedTransaction;

  const Claim({required this.unassignedTransaction});

  @override
  List<Object> get props => [unassignedTransaction];

  @override
  String toString() => 'Claim { unassignedTransaction: $unassignedTransaction }';
}

class Reset extends TransactionPickerScreenEvent {}


