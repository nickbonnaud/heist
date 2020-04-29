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
  final Options currentQuery;
  final dynamic queryParams;

  const TransactionsLoaded({@required this.transactions, @required this.nextPage, @required this.hasReachedEnd, @required this.currentQuery, @required this.queryParams});

  TransactionsLoaded copyWith({
    List<TransactionResource> transactions,
    int nextPage,
    bool hasReachedEnd,
    Options currentQuery,
    dynamic queryParams
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      nextPage: nextPage ?? this.nextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }
  
  @override
  List<Object> get props => [transactions, nextPage, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions, nextPage: $nextPage, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends HistoricTransactionsState {}

