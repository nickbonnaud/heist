import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
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
      super(KeepOpenButtonState.initial());

  @override
  Stream<KeepOpenButtonState> mapEventToState(KeepOpenButtonEvent event) async* {
    if (event is Submitted) {
      yield* _mapKeepOpenSubmitted(event);
    } else if (event is Reset) {
      yield* _mapResetKeepOpen(event);
    }
  }

  Stream<KeepOpenButtonState> _mapKeepOpenSubmitted(Submitted event) async* {
    if (!state.isSubmitting) {
      yield state.update(isSubmitting: true);
      try {
        TransactionResource transactionResource = await _transactionRepository.keepBillOpen(transactionId: event.transactionId);
        yield state.update(
          isSubmitting: false,
          isSubmitSuccess: true,
          isSubmitFailure: false,
        );
        _receiptScreenBloc.add(TransactionChanged(transactionResource: transactionResource));
        _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transactionResource));
      } catch (e) {
        yield state.update(
          isSubmitting: false,
          isSubmitSuccess: false,
          isSubmitFailure: true
        );
      }
    }
  }

  Stream<KeepOpenButtonState> _mapResetKeepOpen(Reset event) async* {
    yield state.update(
      isSubmitting: false,
      isSubmitSuccess: false,
      isSubmitFailure: false
    );
  }
}
