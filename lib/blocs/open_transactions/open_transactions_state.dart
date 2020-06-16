part of 'open_transactions_bloc.dart';

abstract class OpenTransactionsState extends Equatable {
  const OpenTransactionsState();

  @override
  List<Object> get props => [];
  
  List<TransactionResource> get openTransactions => null;
}

class Uninitialized extends OpenTransactionsState {}

class OpenTransactionsLoaded extends OpenTransactionsState {
  final List<TransactionResource> transactions;

  const OpenTransactionsLoaded({@required this.transactions});

  @override
  List<Object> get props => [transactions];

  @override
  String toString() => 'OpenTransactionsLoaded { transactions: $transactions }';
}

class FailedToFetchOpenTransactions extends OpenTransactionsState {}
