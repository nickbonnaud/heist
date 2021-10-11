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
  AuthenticationState _previousAuthenticationState = Unknown();

  OpenTransactionsBloc({required TransactionRepository transactionRepository, required AuthenticationBloc authenticationBloc})
    : _transactionRepository = transactionRepository,
      super(Uninitialized()) {

        _eventHandler();
        
        _authenticationBlocSubscription = authenticationBloc.stream.listen((AuthenticationState state) {
          if (state is Authenticated && (_previousAuthenticationState is Unknown || _previousAuthenticationState is Unauthenticated)) {
            add(FetchOpenTransactions());
          }
          _previousAuthenticationState = state;
        });
      }

  List<TransactionResource> get openTransactions => state.openTransactions;

  void _eventHandler() {
    on<FetchOpenTransactions>((event, emit) async => await _mapFetchOpenTransactionsToState(emit: emit));
    on<AddOpenTransaction>((event, emit) => _mapAddOpenTransactionToState(event: event, emit: emit));
    on<RemoveOpenTransaction>((event, emit) => _mapRemoveOpenTransactionToState(event: event, emit: emit));
    on<UpdateOpenTransaction>((event, emit) => _mapUpdateOpenTransactionToState(event: event, emit: emit));
  }

  @override
  Future<void> close() {
    _authenticationBlocSubscription.cancel();
    return super.close();
  }

  Future<void> _mapFetchOpenTransactionsToState({required Emitter<OpenTransactionsState> emit}) async {
    try {
      List<TransactionResource> transactions = await _transactionRepository.fetchOpen();
      emit(OpenTransactionsLoaded(transactions: transactions));
    } on ApiException catch (exception) {
      emit(FailedToFetchOpenTransactions(errorMessage: exception.error));
    }
  }
  
  void _mapAddOpenTransactionToState({required AddOpenTransaction event, required Emitter<OpenTransactionsState> emit}) {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      if (!currentState.transactions.contains(event.transaction)) {
        final updatedTransactions = currentState
          .transactions
          .toList()
          ..add(event.transaction);
        emit(OpenTransactionsLoaded(transactions: updatedTransactions));
      }
    }
  }

  void _mapRemoveOpenTransactionToState({required RemoveOpenTransaction event, required Emitter<OpenTransactionsState> emit}) {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      final updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction != event.transaction)
        .toList();
      emit(OpenTransactionsLoaded(transactions: updatedTransactions));
    }
  }

  void _mapUpdateOpenTransactionToState({required UpdateOpenTransaction event, required Emitter<OpenTransactionsState> emit}) {
    final currentState = state;
    if (currentState is OpenTransactionsLoaded) {
      final List<TransactionResource> updatedTransactions = currentState
        .transactions
        .where((transaction) => transaction.transaction.identifier != event.transaction.transaction.identifier)
        .toList()
        ..add(event.transaction);
      
      emit(OpenTransactionsLoaded(transactions: updatedTransactions));
    }
  }
}
