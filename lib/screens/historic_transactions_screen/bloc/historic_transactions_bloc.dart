import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/historic_transactions_screen/widgets/filter_button/filter_button.dart';

part 'historic_transactions_event.dart';
part 'historic_transactions_state.dart';


class HistoricTransactionsBloc extends Bloc<HistoricTransactionsEvent, HistoricTransactionsState> {
  final TransactionRepository _transactionRepository;

  HistoricTransactionsBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(Uninitialized());

  @override
  Stream<HistoricTransactionsState> mapEventToState(HistoricTransactionsEvent event) async* {
    if (state is !Loading) {
      if (event is FetchHistoricTransactions) {
        yield* _mapFetchHistoricTransactionsToState(event);
      } else if (event is FetchTransactionsByDateRange) {
        yield* _mapFetchTransactionsByDateRangeToState(event);
      } else if (event is FetchTransactionsByBusiness) {
        yield* _mapFetchTransactionsByBusinessToState(event);
      } else if (event is FetchTransactionByIdentifier) {
        yield* _mapFetchTransactionByIdentifierToState(event);
      } else if (event is FetchMoreTransactions) {
        yield* _mapFetchMoreTransactionsToState();
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchHistoricTransactionsToState(FetchHistoricTransactions event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchHistoric(), currentQuery: Option.all, queryParams: null);
    } else {
      final currentState = state;
      if (currentState is Uninitialized) {
        yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchHistoric(), currentQuery: Option.all, queryParams: null);
      } else if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.all, queryParams: null);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionsByDateRangeToState(FetchTransactionsByDateRange event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchDateRange(dateRange: event.dateRange), currentQuery: Option.date, queryParams: event.dateRange);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.date, queryParams: event.dateRange);
      } 
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionsByBusinessToState(FetchTransactionsByBusiness event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchByBusiness(identifier: event.identifier), currentQuery: Option.businessName, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.businessName, queryParams: event.identifier);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionByIdentifierToState(FetchTransactionByIdentifier event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchByIdentifier(identifier: event.identifier), currentQuery: Option.transactionId, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!,), state: currentState, currentQuery: Option.transactionId, queryParams: event.identifier);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchMoreTransactionsToState() async* {
    final currentState = state;
    if (currentState is TransactionsLoaded && !currentState.paginating) {
      switch (currentState.currentQuery) {
        case Option.all:
          yield* _mapFetchHistoricTransactionsToState(FetchHistoricTransactions(reset: false));
          break;
        case Option.date:
          yield* _mapFetchTransactionsByDateRangeToState(FetchTransactionsByDateRange(dateRange: currentState.queryParams, reset: false));
          break;
        case Option.businessName:
          yield* _mapFetchTransactionsByBusinessToState(FetchTransactionsByBusiness(identifier: currentState.queryParams, reset: false));
          break;
        case Option.transactionId:
          yield* _mapFetchTransactionByIdentifierToState(FetchTransactionByIdentifier(identifier: currentState.queryParams, reset: false));
          break;
        default:
      }
    }
  }

  Stream<HistoricTransactionsState> _fetchUnitialized({required Future<PaginateDataHolder>Function() fetchFunction, required Option currentQuery, required dynamic queryParams}) async* {
    yield Loading();
    try {
      final PaginateDataHolder paginateHolder = await fetchFunction();
      yield TransactionsLoaded(
        transactions: (paginateHolder.data as List<TransactionResource>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      );
    } on ApiException catch(exception) {
      yield FetchFailure(errorMessage: exception.error);
    }
  }

  Stream<HistoricTransactionsState> _fetchMore({required Future<PaginateDataHolder>Function() fetchFunction, required TransactionsLoaded state, required Option currentQuery, required dynamic queryParams}) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState)) {
      yield state.copyWith(paginating: true);
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        yield TransactionsLoaded(
          transactions: currentState.transactions + (paginateHolder.data as List<TransactionResource>), 
          nextUrl: paginateHolder.next,
          paginating: false, 
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        );
      } on ApiException catch (exception) {
        yield FetchFailure(errorMessage: exception.error);
      }
    }
  }

  bool _hasReachedMax(HistoricTransactionsState state) => state is TransactionsLoaded && state.hasReachedEnd;
}
