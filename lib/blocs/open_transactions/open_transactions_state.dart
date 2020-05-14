part of 'open_transactions_bloc.dart';

abstract class OpenTransactionsState extends Equatable {
  const OpenTransactionsState();

  @override
  List<Object> get props => [];
}

class NoOpenTransactions extends OpenTransactionsState {}

class HasOpenTransactions extends OpenTransactionsState {
  final List<TransactionResource> transactions;

  const HasOpenTransactions({@required this.transactions});
  
  @override
  List<Object> get props => [transactions];

  @override
  String toString() => 'HasOpenTransactions { transactions: $transactions }';
}
