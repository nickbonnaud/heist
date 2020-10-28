import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/date_range.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/historic_transactions_screen/widgets/filter_button/filter_button.dart';
import 'package:meta/meta.dart';

part 'historic_transactions_event.dart';
part 'historic_transactions_state.dart';


class HistoricTransactionsBloc extends Bloc<HistoricTransactionsEvent, HistoricTransactionsState> {
  final TransactionRepository _transactionRepository;

  HistoricTransactionsBloc({@required TransactionRepository transactionRepository})
    : assert(transactionRepository != null),
      _transactionRepository = transactionRepository,
      super(Uninitialized());

  @override
  Stream<HistoricTransactionsState> mapEventToState(HistoricTransactionsEvent event) async* {
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

  Stream<HistoricTransactionsState> _mapFetchHistoricTransactionsToState(FetchHistoricTransactions event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchHistoric(nextPage: 1), currentQuery: Option.all, queryParams: null);
    } else {
      final currentState = state;
      if (currentState is Uninitialized) {
        yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchHistoric(nextPage: 1), currentQuery: Option.all, queryParams: null);
      } else if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.fetchHistoric(nextPage: currentState.nextPage), state: currentState, currentQuery: Option.all, queryParams: null);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionsByDateRangeToState(FetchTransactionsByDateRange event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchDateRange(nextPage: 1, dateRange: event.dateRange), currentQuery: Option.date, queryParams: event.dateRange);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.fetchDateRange(nextPage: currentState.nextPage, dateRange: event.dateRange), state: currentState, currentQuery: Option.date, queryParams: event.dateRange);
      } 
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionsByBusinessToState(FetchTransactionsByBusiness event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchByBusiness(nextPage: 1, identifier: event.identifier), currentQuery: Option.businessName, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.fetchByBusiness(nextPage: currentState.nextPage, identifier: event.identifier), state: currentState, currentQuery: Option.businessName, queryParams: event.identifier);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchTransactionByIdentifierToState(FetchTransactionByIdentifier event) async* {
    if (event.reset) {
      yield* _fetchUnitialized(fetchFunction: () => _transactionRepository.fetchByIdentifier(nextPage: 1, identifier: event.identifier), currentQuery: Option.transactionId, queryParams: event.identifier);
    } else {
      final currentState = state;
      if (currentState is TransactionsLoaded) {
        yield* _fetchMore(fetchFunction: () => _transactionRepository.fetchByIdentifier(nextPage: currentState.nextPage, identifier: event.identifier), state: currentState, currentQuery: Option.transactionId, queryParams: event.identifier);
      }
    }
  }

  Stream<HistoricTransactionsState> _mapFetchMoreTransactionsToState() async* {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
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

  Stream<HistoricTransactionsState> _fetchUnitialized({@required Future<PaginateDataHolder>Function() fetchFunction, @required Option currentQuery, @required dynamic queryParams}) async* {
    try {
      yield Loading();
      final PaginateDataHolder paginateData = await fetchFunction();
      yield TransactionsLoaded(
        transactions: paginateData.data,
        nextPage: paginateData.nextPage,
        hasReachedEnd: paginateData.nextPage == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      );
    } catch(_) {
      yield FetchFailure();
    }
  }

  Stream<HistoricTransactionsState> _fetchMore({@required Future<PaginateDataHolder>Function() fetchFunction, @required TransactionsLoaded state, @required Option currentQuery, @required dynamic queryParams}) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState)) {
      try {
        final PaginateDataHolder paginateData = await fetchFunction();
        yield TransactionsLoaded(
          transactions: currentState.transactions + paginateData.data, 
          nextPage: paginateData.nextPage, 
          hasReachedEnd: paginateData.nextPage == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        );
      } catch (_) {
        yield FetchFailure();
      }
    }
  }

  bool _hasReachedMax(HistoricTransactionsState state) => state is TransactionsLoaded && state.hasReachedEnd;
}
