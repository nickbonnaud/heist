import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'keep_open_button_event.dart';
part 'keep_open_button_state.dart';

class KeepOpenButtonBloc extends Bloc<KeepOpenButtonEvent, KeepOpenButtonState> {
  final TransactionRepository _transactionRepository;
  final ReceiptScreenBloc _receiptScreenBloc;
  final OpenTransactionsBloc _openTransactionsBloc;

  KeepOpenButtonBloc({
    required TransactionRepository transactionRepository,
    required ReceiptScreenBloc receiptScreenBloc,
    required OpenTransactionsBloc openTransactionsBloc
  })
    : _transactionRepository = transactionRepository,
      _receiptScreenBloc = receiptScreenBloc,
      _openTransactionsBloc = openTransactionsBloc,
      super(KeepOpenButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Submitted>((event, emit) => _mapKeepOpenSubmitted(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetKeepOpen(event: event, emit: emit));
  }

  void _mapKeepOpenSubmitted({required Submitted event, required Emitter<KeepOpenButtonState> emit}) async {
    if (!state.isSubmitting) {
      emit(state.update(isSubmitting: true));
      try {
        TransactionResource transactionResource = await _transactionRepository.keepBillOpen(transactionId: event.transactionId);
        emit(state.update(isSubmitting: false, isSubmitSuccess: true));
        _receiptScreenBloc.add(TransactionChanged(transactionResource: transactionResource));
        _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transactionResource));
      } on ApiException catch (exception) {
        emit(state.update(isSubmitting: false, errorMessage: exception.error));
      }
    }
  }

  void _mapResetKeepOpen({required Reset event, required Emitter<KeepOpenButtonState> emit}) async {
    emit(state.update(
      isSubmitting: false,
      isSubmitSuccess: false,
      errorMessage: ""
    ));
  }
}
