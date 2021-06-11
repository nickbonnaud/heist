import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
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
      super(PayButtonState.initial(isEnabled: _isButtonEnabled(transactionResource: transactionResource)));

  @override
  Stream<PayButtonState> mapEventToState(PayButtonEvent event) async* {
    if (event is TransactionStatusChanged) {
      yield* _mapTransactionChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState(event: event);
    }
  }
  
  Stream<PayButtonState> _mapTransactionChangedToState(TransactionStatusChanged event) async* {
    yield state.update(
      isEnabled: _isButtonEnabled(transactionResource: event.transactionResource)
    );
  }

  Stream<PayButtonState> _mapSubmittedToState(Submitted event) async* {
    if (state.isEnabled && !state.isSubmitting) {
      yield state.update(isSubmitting: true);
      try {
        TransactionResource transactionResource = await _transactionRepository.approveTransaction(transactionId: event.transactionId);
        if (transactionResource.transaction.status.code == 103) {
          yield state.update(
            isSubmitting: false,  
            isSubmitSuccess: true,
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          );
          _receiptScreenBloc.add(TransactionChanged(transactionResource: transactionResource));
          _openTransactionsBloc.add(RemoveOpenTransaction(transaction: transactionResource));
        } else {
          yield state.update(
            isSubmitting: false, 
            isSubmitFailure: true,
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          );
        }
      } catch (_) {
        yield state.update(
          isSubmitting: false,
          isSubmitFailure: true,
          isSubmitSuccess: false,
          isEnabled: false
        );
      }
    }
  }

  Stream<PayButtonState> _mapResetToState({required Reset event}) async* {
    yield state.update(
      isSubmitFailure: false,
      isSubmitSuccess: false,
      isEnabled: _isButtonEnabled(transactionResource: event.transactionResource),
    );
  }

  static bool _isButtonEnabled({required TransactionResource transactionResource}) {
    List<int> enabledStatusCode = [101, 1020, 1021, 1022, 105, 502];
    return enabledStatusCode.contains(transactionResource.transaction.status.code);
  }
}
