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
      super(Uninitialized()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchHistoricTransactions>((event, emit) async => await _mapFetchHistoricTransactionsToState(event: event, emit: emit));
    on<FetchTransactionsByDateRange>((event, emit) async => await _mapFetchTransactionsByDateRangeToState(event: event, emit: emit));
    on<FetchTransactionsByBusiness>((event, emit) async => await _mapFetchTransactionsByBusinessToState(event: event, emit: emit));
    on<FetchTransactionByIdentifier>((event, emit) async => await _mapFetchTransactionByIdentifierToState(event: event, emit: emit));
    on<FetchMoreTransactions>((event, emit) => _mapFetchMoreTransactionsToState());
  }

  Future<void> _mapFetchHistoricTransactionsToState({required FetchHistoricTransactions event, required Emitter<HistoricTransactionsState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _transactionRepository.fetchHistoric(),
          currentQuery: Option.all,
          queryParams: null,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is Uninitialized) {
          await _fetchUnitialized(
            fetchFunction: () => _transactionRepository.fetchHistoric(),
            currentQuery: Option.all,
            queryParams: null,
            emit: emit
          );
        } else if (currentState is TransactionsLoaded) {
          await _fetchMore(
            fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.all,
            queryParams: null,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchTransactionsByDateRangeToState({required FetchTransactionsByDateRange event, required Emitter<HistoricTransactionsState> emit}) async {
    if (state is !Loading) {  
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _transactionRepository.fetchDateRange(dateRange: event.dateRange),
          currentQuery: Option.date,
          queryParams: event.dateRange,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is TransactionsLoaded) {
          await _fetchMore(
            fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.date,
            queryParams: event.dateRange,
            emit: emit
          );
        } 
      }
    }
  }

  Future<void> _mapFetchTransactionsByBusinessToState({required FetchTransactionsByBusiness event, required Emitter<HistoricTransactionsState> emit}) async {
    if (state is !Loading) {  
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _transactionRepository.fetchByBusiness(identifier: event.identifier),
          currentQuery: Option.businessName,
          queryParams: event.identifier,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is TransactionsLoaded) {
          await _fetchMore(
            fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.businessName,
            queryParams: event.identifier,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchTransactionByIdentifierToState({required FetchTransactionByIdentifier event, required Emitter<HistoricTransactionsState> emit}) async {
    if (state is !Loading) {  
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _transactionRepository.fetchByIdentifier(identifier: event.identifier),
          currentQuery: Option.transactionId,
          queryParams: event.identifier,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is TransactionsLoaded) {
          await _fetchMore(
            fetchFunction: () => _transactionRepository.paginate(url: currentState.nextUrl!,),
            state: currentState,
            currentQuery: Option.transactionId,
            queryParams: event.identifier,
            emit: emit
          );
        }
      }
    }
  }

  void _mapFetchMoreTransactionsToState() async {
    if (state is !Loading) {  
      final currentState = state;
      if (currentState is TransactionsLoaded && !currentState.paginating) {
        switch (currentState.currentQuery) {
          case Option.all:
            add(const FetchHistoricTransactions(reset: false));
            break;
          case Option.date:
            add(FetchTransactionsByDateRange(dateRange: currentState.queryParams, reset: false));
            break;
          case Option.businessName:
            add(FetchTransactionsByBusiness(identifier: currentState.queryParams, reset: false));
            break;
          case Option.transactionId:
            add(FetchTransactionByIdentifier(identifier: currentState.queryParams, reset: false));
            break;
          default:
        }
      }
    }
  }

  Future<void> _fetchUnitialized({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<HistoricTransactionsState> emit
  }) async {
    emit(Loading());
    try {
      final PaginateDataHolder paginateHolder = await fetchFunction();
      emit(TransactionsLoaded(
        transactions: (paginateHolder.data as List<TransactionResource>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      ));
    } on ApiException catch(exception) {
      emit(FetchFailure(errorMessage: exception.error));
    }
  }

  Future<void> _fetchMore({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required TransactionsLoaded state,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<HistoricTransactionsState> emit
  }) async {
    final currentState = state;
    if (!_hasReachedMax(currentState)) {
      emit(state.copyWith(paginating: true));
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        emit(TransactionsLoaded(
          transactions: currentState.transactions + (paginateHolder.data as List<TransactionResource>), 
          nextUrl: paginateHolder.next,
          paginating: false, 
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        ));
      } on ApiException catch (exception) {
        emit(FetchFailure(errorMessage: exception.error));
      }
    }
  }

  bool _hasReachedMax(HistoricTransactionsState state) => state is TransactionsLoaded && state.hasReachedEnd;
}
