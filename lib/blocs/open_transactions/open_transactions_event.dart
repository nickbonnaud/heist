part of 'open_transactions_bloc.dart';

abstract class OpenTransactionsEvent extends Equatable {
  const OpenTransactionsEvent();

  @override
  List<Object> get props => [];
}

class FetchOpenTransactions extends OpenTransactionsEvent {}

class AddOpenTransaction extends OpenTransactionsEvent {
  final TransactionResource transaction;

  const AddOpenTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];

  @override
  String toString() => 'AddOpenTransaction { transaction: $transaction }';
}

class RemoveOpenTransaction extends OpenTransactionsEvent {
  final TransactionResource transaction;

  const RemoveOpenTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];

  @override
  String toString() => 'RemoveOpenTransaction { transaction: $transaction }';
}

class UpdateOpenTransaction extends OpenTransactionsEvent {
  final TransactionResource transaction;

  const UpdateOpenTransaction({required this.transaction});

  @override
  List<Object> get props => [transaction];

   @override
  String toString() => 'UpdateOpenTransaction { transaction: $transaction }';
}
