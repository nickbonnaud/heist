import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'pay_button_event.dart';
part 'pay_button_state.dart';

class PayButtonBloc extends Bloc<PayButtonEvent, PayButtonState> {
  final TransactionRepository _transactionRepository;
  final ReceiptScreenBloc _receiptScreenBloc;
  final OpenTransactionsBloc _openTransactionsBloc;
  
  PayButtonBloc({
    required TransactionRepository transactionRepository,
    required ReceiptScreenBloc receiptScreenBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required TransactionResource transactionResource,
  })
    : _transactionRepository = transactionRepository,
      _receiptScreenBloc = receiptScreenBloc,
      _openTransactionsBloc = openTransactionsBloc,
      super(PayButtonState.initial(isEnabled: _isButtonEnabled(transactionResource: transactionResource))) {
        _eventHandler();
  }

  void _eventHandler() {
    on<TransactionStatusChanged>((event, emit) => _mapTransactionChangedToState(event: event, emit: emit));
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(event: event, emit: emit));
  }
  
  void _mapTransactionChangedToState({required TransactionStatusChanged event, required Emitter<PayButtonState> emit}) async {
    emit(state.update(
      isEnabled: _isButtonEnabled(transactionResource: event.transactionResource)
    ));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<PayButtonState> emit}) async {
    if (state.isEnabled && !state.isSubmitting) {
      emit(state.update(isSubmitting: true));
      try {
        TransactionResource transactionResource = await _transactionRepository.approveTransaction(transactionId: event.transactionId);
        if (transactionResource.transaction.status.code == 103) {
          emit(state.update(
            isSubmitting: false,  
            isSubmitSuccess: true,
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          ));
          _receiptScreenBloc.add(TransactionChanged(transactionResource: transactionResource));
          _openTransactionsBloc.add(RemoveOpenTransaction(transaction: transactionResource));
        } else {
          _receiptScreenBloc.add(TransactionChanged(transactionResource: transactionResource));
          emit(state.update(
            isSubmitting: false, 
            errorMessage: "Oops! Something went wrong submitting payment.",
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          ));
        }
      } on ApiException catch (exception) {
        emit(state.update(isSubmitting: false, errorMessage: exception.error ));
      }
    }
  }

  void _mapResetToState({required Reset event, required Emitter<PayButtonState> emit}) async {
    emit(state.update(
      errorMessage: "",
      isSubmitSuccess: false,
      isEnabled: _isButtonEnabled(transactionResource: event.transactionResource),
    ));
  }

  static bool _isButtonEnabled({required TransactionResource transactionResource}) {
    List<int> enabledStatusCode = [101, 1020, 1021, 1022, 105, 502];
    return enabledStatusCode.contains(transactionResource.transaction.status.code);
  }
}
