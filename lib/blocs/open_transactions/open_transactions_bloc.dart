import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/boot/boot_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'open_transactions_event.dart';
part 'open_transactions_state.dart';

class OpenTransactionsBloc extends Bloc<OpenTransactionsEvent, OpenTransactionsState> {
  final TransactionRepository _transactionRepository;
  final BootBloc _bootBloc;

  OpenTransactionsBloc({@required TransactionRepository transactionRepository, @required BootBloc bootBloc})
    : assert(transactionRepository != null && bootBloc != null),
      _transactionRepository = transactionRepository,
      _bootBloc = bootBloc,
      super(Uninitialized());

  List<TransactionResource> get openTransactions => state.openTransactions;

  @override
  Stream<OpenTransactionsState> mapEventToState(OpenTransactionsEvent event) async* {
    if (event is FetchOpenTransactions) {
      yield* _mapFetchOpenTransactionsToState();
    } else if (event is AddOpenTransaction) {
      yield* _mapAddOpenTransactionToState(event);
    } else if (event is RemoveOpenTransaction) {
      yield* _mapRemoveOpenTransactionToState(event);
    } else if (event is UpdateOpenTransaction) {
      yield* _mapUpdateOpenTransactionToState(event);
    }
  }

  Stream<OpenTransactionsState> _mapFetchOpenTransactionsToState() async* {
    try {
      List<TransactionResource> transactions = await _transactionRepository.fetchOpen();
      yield OpenTransactionsLoaded(transactions: transactions);
      _bootBloc.add(DataLoaded(type: DataType.transactions));
    } catch (e) {
      yield FailedToFetchOpenTransactions();
      _bootBloc.add(DataLoaded(type: DataType.transactions));
    }
  }
  
  Stream<OpenTransactionsState> _mapAddOpenTransactionToState(AddOpenTransaction event) async* {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      if (!currentState.transactions.contains(event.transaction)) {
        final updatedTransactions = currentState
          .transactions
          .toList()
          ..add(event.transaction);
        yield OpenTransactionsLoaded(transactions: updatedTransactions);
      }
    }
  }

  Stream<OpenTransactionsState> _mapRemoveOpenTransactionToState(RemoveOpenTransaction event) async* {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      final updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction.transaction.identifier != event.transaction.transaction.identifier)
        .toList();
      yield OpenTransactionsLoaded(transactions: updatedTransactions);
    }
  }

  Stream<OpenTransactionsState> _mapUpdateOpenTransactionToState(UpdateOpenTransaction event) async* {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      final List<TransactionResource> updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction.transaction.identifier != event.transaction.transaction.identifier)
        .toList()
        ..add(event.transaction);
      
      yield OpenTransactionsLoaded(transactions: updatedTransactions);
    }
  }
}
