part of 'open_transactions_bloc.dart';

abstract class OpenTransactionsState extends Equatable {
  const OpenTransactionsState();

  @override
  List<Object> get props => [];
  
  List<TransactionResource> get openTransactions => [];
}

class Uninitialized extends OpenTransactionsState {}

class OpenTransactionsLoaded extends OpenTransactionsState {
  final List<TransactionResource> transactions;

  const OpenTransactionsLoaded({required this.transactions});

  @override
  List<Object> get props => [transactions];

  @override
  List<TransactionResource> get openTransactions => transactions;

  @override
  String toString() => 'OpenTransactionsLoaded { transactions: $transactions }';
}

class FailedToFetchOpenTransactions extends OpenTransactionsState {
  final String errorMessage;

  const FailedToFetchOpenTransactions({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'FailedToFetchOpenTransactions { errorMessage: $errorMessage }';
}
