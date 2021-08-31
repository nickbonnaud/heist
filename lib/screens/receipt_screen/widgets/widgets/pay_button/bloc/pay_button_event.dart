part of 'pay_button_bloc.dart';

abstract class PayButtonEvent extends Equatable {
  const PayButtonEvent();

  @override
  List<Object> get props => [];
}

class TransactionStatusChanged extends PayButtonEvent {
  final TransactionResource transactionResource;

  const TransactionStatusChanged({required this.transactionResource});

  @override
  List<Object> get props => [transactionResource];

  @override
  String toString() => 'TransactionStatusChanged { transactionResource: $transactionResource }';
}

class Submitted extends PayButtonEvent {
  final String transactionId;

  const Submitted({required this.transactionId});

  @override
  List<Object> get props => [transactionId];

  @override
  String toString() => 'Submitted { transactionId: $transactionId }';
}

class Reset extends PayButtonEvent {
  final TransactionResource transactionResource;

  const Reset({required this.transactionResource});

  @override
  List<Object> get props => [transactionResource];

  @override
  String toString() => 'Reset { transactionResource: $transactionResource }';
}
