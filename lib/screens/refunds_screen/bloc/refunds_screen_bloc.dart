import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/refund_resource.dart';
import 'package:heist/repositories/refund_repository.dart';
import 'package:heist/screens/refunds_screen/widgets/filter_button/filter_button.dart';
import 'package:meta/meta.dart';

part 'refunds_screen_event.dart';
part 'refunds_screen_state.dart';

class RefundsScreenBloc extends Bloc<RefundsScreenEvent, RefundsScreenState> {
  final RefundRepository _refundRepository;

  RefundsScreenBloc({required RefundRepository refundRepository})
    : _refundRepository = refundRepository,
      super(Uninitialized());

  @override
  Stream<RefundsScreenState> mapEventToState(RefundsScreenEvent event) async* {
    if (state is !Loading) {
      if (event is FetchAllRefunds) {
        yield* _mapFetchAllRefundsToState(event);
      } else if (event is FetchRefundsByDateRange) {
        yield* _mapFetchRefundsByDateRangeToState(event);
      } else if (event is FetchRefundByIdentifier) {
        yield* _mapFetchRefundByIdentifierToState(event);
      } else if (event is FetchRefundByBusiness) {
        yield* _mapFetchRefundByBusinessToState(event);
      } else if (event is FetchRefundByTransaction) {
        yield* _mapFetchRefundByTransactionToState(event);
      } else if (event is FetchMoreRefunds) {
        yield* _mapFetchMoreRefundsToState();
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchAllRefundsToState(FetchAllRefunds event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchAll(), state: state, currentQuery: Option.all, queryParams: null);
    } else {
      final currentState = state;
      if (currentState is Uninitialized) {
        yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchAll(), state: currentState, currentQuery: Option.all, queryParams: null);
      } else if (currentState is RefundsLoaded) {
        yield* _fetchMore(fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.all, queryParams: null);
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchRefundsByDateRangeToState(FetchRefundsByDateRange event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchAll(dateRange: event.dateRange), state: state, currentQuery: Option.date, queryParams: event.dateRange);
    } else {
      final currentState = state;
      if (currentState is RefundsLoaded) {
        yield* _fetchMore(fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.date, queryParams: event.dateRange);
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchRefundByIdentifierToState(FetchRefundByIdentifier event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchByIdentifier(identifier: event.identifier), state: state, currentQuery: Option.refundId, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is RefundsLoaded) {
        yield* _fetchMore(fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.refundId, queryParams: event.identifier);
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchRefundByBusinessToState(FetchRefundByBusiness event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchByBusiness(identifier: event.identifier), state: state, currentQuery: Option.businessName, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is RefundsLoaded) {
        yield* _fetchMore(fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.businessName, queryParams: event.identifier);
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchRefundByTransactionToState(FetchRefundByTransaction event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _refundRepository.fetchByTransactionIdentifier(identifier: event.identifier), state: state, currentQuery: Option.transactionId, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is RefundsLoaded) {
        yield* _fetchMore(fetchFunction: () => _refundRepository.paginate(url: currentState.nextUrl!), state: currentState, currentQuery: Option.transactionId, queryParams: event.identifier);
      }
    }
  }

  Stream<RefundsScreenState> _mapFetchMoreRefundsToState() async* {
    final currentState = state;
    if (currentState is RefundsLoaded) {
      switch (currentState.currentQuery) {
        case Option.all:
          yield* _mapFetchAllRefundsToState(FetchAllRefunds(reset: false));
          break;
        case Option.date:
          yield* _mapFetchRefundsByDateRangeToState(FetchRefundsByDateRange(dateRange: currentState.queryParams, reset: false));
          break;
        case Option.refundId:
          yield* _mapFetchRefundByIdentifierToState(FetchRefundByIdentifier(identifier: currentState.queryParams, reset: false));
          break;
        case Option.businessName:
          yield* _mapFetchRefundByBusinessToState(FetchRefundByBusiness(identifier: currentState.queryParams, reset: false));
          break;
        case Option.transactionId:
          yield* _mapFetchRefundByTransactionToState(FetchRefundByTransaction(identifier: currentState.queryParams, reset: false));
          break;
      }
    }
  }
  
  Stream<RefundsScreenState> _fetchUnitialized({required Future<PaginateDataHolder>Function() fetchFunction, required RefundsScreenState state, required Option currentQuery, required dynamic queryParams}) async* {
    try {
      yield Loading();
      final PaginateDataHolder paginateHolder = await fetchFunction();
      yield RefundsLoaded(
        refunds: (paginateHolder.data as List<RefundResource>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      );
    } catch (_) {
      yield FetchFailure();
    }
  }

  Stream<RefundsScreenState> _fetchMore({required Future<PaginateDataHolder>Function() fetchFunction, required RefundsLoaded state, required Option currentQuery, required dynamic queryParams}) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState)) {
      yield state.update(paginating: true);
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        yield RefundsLoaded(
          refunds: currentState.refunds + (paginateHolder.data as List<RefundResource>),
          paginating: false,
          nextUrl: paginateHolder.next, 
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        );
      } catch (_) {
        yield FetchFailure();
      }
    }
  }

  bool _hasReachedMax(RefundsScreenState state) => state is RefundsLoaded && state.hasReachedEnd;
}
