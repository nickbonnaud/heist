import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/refunds_screen/widgets/filter_button/filter_button.dart';

part 'refunds_screen_event.dart';
part 'refunds_screen_state.dart';

class RefundsScreenBloc extends Bloc<RefundsScreenEvent, RefundsScreenState> {
  final RefundRepository _refundRepository;

  RefundsScreenBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(Uninitialized()) { _eventHandler(); }

  void _eventHandler() {
    on<FetchAllRefunds>((event, emit) async => await _mapFetchAllRefundsToState(event: event, emit: emit));
    on<FetchRefundsByDateRange>((event, emit) async => await _mapFetchRefundsByDateRangeToState(event: event, emit: emit));
    on<FetchRefundByIdentifier>((event, emit) async => await _mapFetchRefundByIdentifierToState(event: event, emit: emit));
    on<FetchRefundByBusiness>((event, emit) async => await _mapFetchRefundByBusinessToState(event: event, emit: emit));
    on<FetchRefundByTransaction>((event, emit) async => await _mapFetchRefundByTransactionToState(event: event, emit: emit));
    on<FetchMoreRefunds>((event, emit) => _mapFetchMoreRefundsToState());
  }

  Future<void> _mapFetchAllRefundsToState({required FetchAllRefunds event, required Emitter<RefundsScreenState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _refundRepository.fetchAll(),
          state: state,
          currentQuery: Option.all,
          queryParams: null,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is Uninitialized) {
          await _fetchUnitialized(
            fetchFunction: () => _refundRepository.fetchAll(),
            state: currentState,
            currentQuery: Option.all,
            queryParams: null,
            emit: emit
          );
        } else if (currentState is RefundsLoaded) {
          await _fetchMore(
            fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.all,
            queryParams: null,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchRefundsByDateRangeToState({required FetchRefundsByDateRange event, required Emitter<RefundsScreenState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _refundRepository.fetchAll(dateRange: event.dateRange),
          state: state,
          currentQuery: Option.date,
          queryParams: event.dateRange,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is RefundsLoaded) {
          await _fetchMore(
            fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!),
            state: currentState, 
            currentQuery: Option.date,
            queryParams: event.dateRange,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchRefundByIdentifierToState({required FetchRefundByIdentifier event, required Emitter<RefundsScreenState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _refundRepository.fetchByIdentifier(identifier: event.identifier),
          state: state,
          currentQuery: Option.refundId,
          queryParams: event.identifier,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is RefundsLoaded) {
          await _fetchMore(
            fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.refundId,
            queryParams: event.identifier,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchRefundByBusinessToState({required FetchRefundByBusiness event, required Emitter<RefundsScreenState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _refundRepository.fetchByBusiness(identifier: event.identifier),
          state: state,
          currentQuery: Option.businessName,
          queryParams: event.identifier,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is RefundsLoaded) {
          await _fetchMore(
            fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.businessName,
            queryParams: event.identifier,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchRefundByTransactionToState({required FetchRefundByTransaction event, required Emitter<RefundsScreenState> emit}) async {
    if (state is !Loading) {
      if (event.reset) {
        await _fetchUnitialized(
          fetchFunction: () => _refundRepository.fetchByTransactionIdentifier(identifier: event.identifier),
          state: state,
          currentQuery: Option.transactionId,
          queryParams: event.identifier,
          emit: emit
        );
      } else {
        final currentState = state;
        if (currentState is RefundsLoaded) {
          await _fetchMore(
            fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.transactionId,
            queryParams: event.identifier,
            emit: emit
          );
        }
      }
    }
  }

  void _mapFetchMoreRefundsToState() {
    final currentState = state;
    if (currentState is RefundsLoaded && !currentState.paginating) {
      switch (currentState.currentQuery) {
        case Option.all:
          add(const FetchAllRefunds(reset: false));
          break;
        case Option.date:
          add(FetchRefundsByDateRange(dateRange: currentState.queryParams, reset: false));
          break;
        case Option.refundId:
          add(FetchRefundByIdentifier(identifier: currentState.queryParams, reset: false));
          break;
        case Option.businessName:
          add(FetchRefundByBusiness(identifier: currentState.queryParams, reset: false));
          break;
        case Option.transactionId:
          add(FetchRefundByTransaction(identifier: currentState.queryParams, reset: false));
          break;
      }
    }
  }
  
  Future<void> _fetchUnitialized({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required RefundsScreenState state,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<RefundsScreenState> emit
  }) async {
    emit(Loading());
    try {
      final PaginateDataHolder paginateHolder = await fetchFunction();
      emit(RefundsLoaded(
        refunds: (paginateHolder.data as List<RefundResource>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      ));
    } on ApiException catch (exception) {
      emit(FetchFailure(errorMessage: exception.error));
    }
  }

  Future<void> _fetchMore({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required RefundsLoaded state,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<RefundsScreenState> emit
  }) async {
    final currentState = state;
    if (!_hasReachedMax(state: currentState)) {
      emit(state.update(paginating: true));
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        emit(RefundsLoaded(
          refunds: currentState.refunds + (paginateHolder.data as List<RefundResource>),
          paginating: false,
          nextUrl: paginateHolder.next, 
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        ));
      } on ApiException catch (exception) {
        emit(FetchFailure(errorMessage: exception.error));
      }
    }
  }

  bool _hasReachedMax({required RefundsScreenState state}) => state is RefundsLoaded && state.hasReachedEnd;
}
