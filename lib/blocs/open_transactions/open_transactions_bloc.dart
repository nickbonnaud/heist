import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:meta/meta.dart';

part 'open_transactions_event.dart';
part 'open_transactions_state.dart';

class OpenTransactionsBloc extends Bloc<OpenTransactionsEvent, OpenTransactionsState> {
  @override
  OpenTransactionsState get initialState => NoOpenTransactions();

  @override
  Stream<OpenTransactionsState> mapEventToState(OpenTransactionsEvent event) async* {
    if (event is AddOpenTransaction) {
      yield* _mapAddOpenTransactionToState(event);
    } else if (event is RemoveOpenTransaction) {
      yield* _mapRemoveOpenTransactionToState(event);
    }
  }

  Stream<OpenTransactionsState> _mapAddOpenTransactionToState(AddOpenTransaction event) async* {
    final currentState = state;
    if (currentState is NoOpenTransactions) {
      yield HasOpenTransactions(transactions: [event.transaction].toList());
    } else if (currentState is HasOpenTransactions) {
      if (currentState.transactions.indexWhere((transaction) => transaction.transaction.identifier == event.transaction.transaction.identifier) < 0) {
        yield HasOpenTransactions(transactions: currentState.transactions + [event.transaction].toList());
      }
    }
  }

  Stream<OpenTransactionsState> _mapRemoveOpenTransactionToState(RemoveOpenTransaction event) async* {
    final currentState = state;
    if (currentState is HasOpenTransactions) {
      final updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction.transaction.identifier != event.transaction.transaction.identifier)
        .toList();
      yield updatedTransactions.length == 0
        ? NoOpenTransactions()
        : HasOpenTransactions(transactions: updatedTransactions);
    }
  }
}
