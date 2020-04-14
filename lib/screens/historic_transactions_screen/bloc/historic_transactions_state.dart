part of 'historic_transactions_bloc.dart';

abstract class HistoricTransactionsState extends Equatable {
  const HistoricTransactionsState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends HistoricTransactionsState {}

class Loading extends HistoricTransactionsState {}

class TransactionsLoaded extends HistoricTransactionsState {
  final List<TransactionResource> transactions;
  final int nextPage;
  final bool hasReachedEnd;

  const TransactionsLoaded({@required this.transactions, @required this.nextPage, @required this.hasReachedEnd});

  TransactionsLoaded copyWith({
    List<TransactionResource> transactions,
    int nextPage,
    bool hasReachedEnd
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      nextPage: nextPage ?? this.nextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd
    );
  }
  
  @override
  List<Object> get props => [transactions, nextPage, hasReachedEnd];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions, nextPage: $nextPage, hasReachedEnd: $hasReachedEnd }';
}

class FetchFailure extends HistoricTransactionsState {}

