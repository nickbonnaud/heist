part of 'historic_transactions_bloc.dart';

abstract class HistoricTransactionsEvent extends Equatable {
  const HistoricTransactionsEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricTransactions extends HistoricTransactionsEvent {
  final bool reset;

  const FetchHistoricTransactions({this.reset = false});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'FetchHistoricTransactions { reset: $reset }';
}

class FetchTransactionsByDateRange extends HistoricTransactionsEvent {
  final DateRange dateRange;
  final bool reset;

  const FetchTransactionsByDateRange({@required this.dateRange, this.reset = false});

  @override
  List<Object> get props => [dateRange, reset];

  @override
  String toString() => 'FetchTransactionsByDateRange { dateRange: $dateRange, reset: $reset }';
}
