import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

part 'transaction_picker_screen_event.dart';
part 'transaction_picker_screen_state.dart';

class TransactionPickerScreenBloc extends Bloc<TransactionPickerScreenEvent, TransactionPickerScreenState> {
  final TransactionRepository _transactionRepository;
  final ActiveLocationBloc _activeLocationBloc;
  final OpenTransactionsBloc _openTransactionsBloc;

  TransactionPickerScreenBloc({
    required TransactionRepository transactionRepository,
    required ActiveLocationBloc activeLocationBloc,
    required OpenTransactionsBloc openTransactionsBloc
  })
    : _transactionRepository = transactionRepository,
      _activeLocationBloc = activeLocationBloc,
      _openTransactionsBloc = openTransactionsBloc,
      super(TransactionPickerScreenState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Fetch>((event, emit) => _mapFetchToState(event: event, emit: emit));
    on<Claim>((event, emit) => _mapClaimToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapFetchToState({required Fetch event, required Emitter<TransactionPickerScreenState> emit}) async {
    emit(state.update(loading: true));
    try {
      final List<UnassignedTransactionResource> transactions = await _transactionRepository.fetchUnassigned(businessIdentifier: event.businessIdentifier);
      emit(state.update(loading: false, transactions: transactions));
    } on ApiException catch (exception) {
      emit(state.update(loading: false, errorMessage: exception.error));
    }
  }

  void _mapClaimToState({required Claim event, required Emitter<TransactionPickerScreenState> emit}) async {
    emit(state.update(claiming: true));
    try {
      final TransactionResource transaction = await _transactionRepository.claimUnassigned(transactionId: event.unassignedTransaction.transaction.identifier);
      _updateBlocs(transaction: transaction, business: event.unassignedTransaction.business);
      emit(state.update(claiming: false, claimSuccess: true, transaction: transaction));
    } on ApiException catch (exception) {
      emit(state.update(claiming: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<TransactionPickerScreenState> emit}) async {
    emit(state.update(claiming: false, errorMessage: "", claimSuccess: false));
  }

  void _updateBlocs({required TransactionResource transaction, required Business business}) {
    _activeLocationBloc.add(TransactionAdded(
      business: business,
      transactionIdentifier: transaction.transaction.identifier
    ));

    _openTransactionsBloc.add(AddOpenTransaction(transaction: transaction));
  }
}
