import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'transaction_picker_screen_event.dart';
part 'transaction_picker_screen_state.dart';

class TransactionPickerScreenBloc extends Bloc<TransactionPickerScreenEvent, TransactionPickerScreenState> {
  final TransactionRepository _transactionRepository;

  TransactionPickerScreenBloc({required TransactionRepository transactionRepository})
    : _transactionRepository = transactionRepository,
      super(Uninitialized());

  @override
  Stream<TransactionPickerScreenState> mapEventToState(TransactionPickerScreenEvent event) async* {
    if (event is Fetch) {
      yield* _mapFetchToState(event);
    } else if (event is Claim) {
      yield* _mapClaimToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<TransactionPickerScreenState> _mapFetchToState(Fetch event) async* {
    yield Loading();
    try {
      final List<UnassignedTransactionResource> transactions = await _transactionRepository.fetchUnassigned(businessIdentifier: event.businessIdentifier);
      yield TransactionsLoaded(transactions: transactions);
    } on ApiException catch (exception) {
      yield FetchFailure(errorMessage: exception.error);
    }
  }

  Stream<TransactionPickerScreenState> _mapClaimToState(Claim event) async* {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
      yield currentState.update(claiming: true);
      try {
        final TransactionResource transaction = await _transactionRepository.claimUnassigned(transactionId: event.transactionIdentifier);
        yield currentState.update(claiming: false, claimSuccess: true, transaction: transaction);
      } on ApiException catch (exception) {
        yield currentState.update(claiming: false, errorMessage: exception.error);
      }
    }
  }

  Stream<TransactionPickerScreenState> _mapResetToState() async* {
    final currentState = state;
    if (currentState is TransactionsLoaded) {
      yield currentState.update(claiming: false, errorMessage: "", claimSuccess: false);
    }
  }
}
