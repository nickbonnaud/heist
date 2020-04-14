import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/paginated_api_response.dart';
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
  Stream<HistoricTransactionsState> transformEvents(Stream<HistoricTransactionsEvent> events, Stream<HistoricTransactionsState> Function(HistoricTransactionsEvent) next) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      next
    );
  }
  
  @override
  Stream<HistoricTransactionsState> mapEventToState( HistoricTransactionsEvent event) async* {
    final currentState = state;
    if (event is FetchHistoricTransactions && !_hasReachedMax(currentState)) {
      try {
        if (currentState is Uninitialized) {
          final PaginateDataHolder paginateData = await _transactionRepository.fetchPaid(1);
          yield TransactionsLoaded(transactions: paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: paginateData.nextPage == null);
          return;
        }

        if (currentState is TransactionsLoaded) {
          final PaginateDataHolder paginateData = await _transactionRepository.fetchPaid(currentState.nextPage);
          yield paginateData.nextPage == null 
            ? currentState.copyWith(hasReachedEnd: true)
            : TransactionsLoaded(transactions: currentState.transactions + paginateData.data, nextPage: paginateData.nextPage, hasReachedEnd: false);
        }
      } catch (_) {
        yield FetchFailure();
      }
    }
  }

  bool _hasReachedMax(HistoricTransactionsState state) => state is TransactionsLoaded && state.hasReachedEnd;
}
