part of 'historic_transactions_bloc.dart';

abstract class HistoricTransactionsState extends Equatable {
  const HistoricTransactionsState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends HistoricTransactionsState {}

class Loading extends HistoricTransactionsState {}

class TransactionsLoaded extends HistoricTransactionsState {
  final List<TransactionResource> transactions;
  final String? nextUrl;
  final bool paginating;
  final bool hasReachedEnd;
  final Option currentQuery;
  final dynamic queryParams;

  const TransactionsLoaded({
    required this.transactions,
    this.nextUrl,
    required this.paginating,
    required this.hasReachedEnd,
    required this.currentQuery,
    required this.queryParams
  });

  TransactionsLoaded copyWith({
    List<TransactionResource>? transactions,
    String? nextUrl,
    bool? paginating,
    bool? hasReachedEnd,
    Option? currentQuery,
    dynamic queryParams
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      paginating: paginating ?? this.paginating,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }
  
  @override
  List<Object?> get props => [transactions, nextUrl, paginating, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions, nextUrl: $nextUrl, paginating: $paginating, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends HistoricTransactionsState {
  final String errorMessage;

  const FetchFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'FetchFailure { errorMessage: $errorMessage }';
}

