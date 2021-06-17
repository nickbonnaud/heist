import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'open_transactions_event.dart';
part 'open_transactions_state.dart';

class OpenTransactionsBloc extends Bloc<OpenTransactionsEvent, OpenTransactionsState> {
  final TransactionRepository _transactionRepository;

  late StreamSubscription _authenticationBlocSubscription;
  late AuthenticationState _previousAuthenticationState;

  OpenTransactionsBloc({required TransactionRepository transactionRepository, required AuthenticationBloc authenticationBloc})
    : _transactionRepository = transactionRepository,
      super(Uninitialized()) {
        _authenticationBlocSubscription = authenticationBloc.stream.listen((AuthenticationState state) {
          if (state is Authenticated && (_previousAuthenticationState is Unknown || _previousAuthenticationState is Unauthenticated)) {
            add(FetchOpenTransactions());
          }
          _previousAuthenticationState = state;
        });
      }

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

  @override
  Future<void> close() {
    _authenticationBlocSubscription.cancel();
    return super.close();
  }

  Stream<OpenTransactionsState> _mapFetchOpenTransactionsToState() async* {
    try {
      List<TransactionResource> transactions = await _transactionRepository.fetchOpen();
      yield OpenTransactionsLoaded(transactions: transactions);
    } on ApiException catch (exception) {
      yield FailedToFetchOpenTransactions(errorMessage: exception.error);
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
        .where((transaction) => transaction != event.transaction)
        .toList();
      yield OpenTransactionsLoaded(transactions: updatedTransactions);
    }
  }

  Stream<OpenTransactionsState> _mapUpdateOpenTransactionToState(UpdateOpenTransaction event) async* {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      final List<TransactionResource> updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction != event.transaction)
        .toList()
        ..add(event.transaction);
      
      yield OpenTransactionsLoaded(transactions: updatedTransactions);
    }
  }
}
