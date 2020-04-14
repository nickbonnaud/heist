part of 'historic_transactions_bloc.dart';

abstract class HistoricTransactionsEvent extends Equatable {
  const HistoricTransactionsEvent();

  @override
  List<Object> get props => [];
}

class FetchHistoricTransactions extends HistoricTransactionsEvent {}
