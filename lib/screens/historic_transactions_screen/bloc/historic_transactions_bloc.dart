import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'historic_transactions_event.dart';
part 'historic_transactions_state.dart';


class HistoricTransactionsBloc extends Bloc<HistoricTransactionsEvent, HistoricTransactionsState> {
  final TransactionRepository _transactionRepository;

  HistoricTransactionsBloc({@required TransactionRepository transactionRepository})
    : assert(transactionRepository != null),
      _transactionRepository = transactionRepository;
  
  @override
  HistoricTransactionsState get initialState => Uninitialized();

  @override
  Stream<HistoricTransactionsState> mapEventToState(HistoricTransactionsEvent event) async* {
    if (event is FetchHistoricTransactions) {
      yield* _mapFetchHistoricTransactionsToState(event);
    } else if (event is FetchTransactionsByDateRange) {
      yield* _mapFetchTransactionsByDateRangeToState(event);
    }
  }

  Stream<HistoricTransactionsState> _mapFetchHistoricTransactionsToState(FetchHistoricTransactions event) async* {
    if (state is !Loading) {
      if (event.reset) {
        try {
          yield Loading();
          final PaginateDataHolder paginateData = await _transactionRepository.fetchHistoric(1);
          yield TransactionsLoaded(transactions: paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: paginateData.nextPage == null);
        } catch (_) {
          yield FetchFailure();
        }
      } else {
        final currentState = state;
        if (!_hasReachedMax(currentState)) {
          try {
            yield Loading();
            if (currentState is Uninitialized) {
              final PaginateDataHolder paginateData = await _transactionRepository.fetchHistoric(1);
              yield TransactionsLoaded(transactions: paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: paginateData.nextPage == null);
              return;
            }

            if (currentState is TransactionsLoaded) {
              final PaginateDataHolder paginateData = await _transactionRepository.fetchHistoric(currentState.nextPage);
              yield paginateData.nextPage == null 
                ? currentState.copyWith(hasReachedEnd: true)
                : TransactionsLoaded(transactions: currentState.transactions + paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: false);
            }
          } catch (_) {
            yield FetchFailure();
          }
        }
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionsByDateRangeToState(FetchTransactionsByDateRange event) async* {
    if (state is !Loading) {
      if (event.reset) {
        try {
          yield Loading();
          final PaginateDataHolder paginateData = await _transactionRepository.fetchDateRange(nextPage: 1, dateRange: event.dateRange);
          yield TransactionsLoaded(transactions: paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: paginateData.nextPage == null);
        } catch (_) {
          yield FetchFailure();
        }
      } else {
        final currentState = state;
        print("1");
        if (!_hasReachedMax(currentState)) {
          print("2");
          try {
            yield Loading();
            if (currentState is Uninitialized) {
              print("3");
              final PaginateDataHolder paginateData = await _transactionRepository.fetchDateRange(nextPage: 1, dateRange: event.dateRange);
              yield TransactionsLoaded(transactions: paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: paginateData.nextPage == null);
              return;
            }

            if (currentState is TransactionsLoaded) {
              print("4");
              final PaginateDataHolder paginateData = await _transactionRepository.fetchDateRange(nextPage: currentState.nextPage, dateRange: event.dateRange);
              print("5");
              yield paginateData.nextPage == null 
                ? currentState.copyWith(hasReachedEnd: true)
                : TransactionsLoaded(transactions: currentState.transactions + paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: false);
            }
          } catch (_) {
            print("6");
            yield FetchFailure();
          }
        }
      }
    }
  }

  bool _hasReachedMax(HistoricTransactionsState state) => state is TransactionsLoaded && state.hasReachedEnd;
}