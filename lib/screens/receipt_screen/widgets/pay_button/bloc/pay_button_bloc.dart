import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'pay_button_event.dart';
part 'pay_button_state.dart';

class PayButtonBloc extends Bloc<PayButtonEvent, PayButtonState> {
  final TransactionRepository _transactionRepository;
  
  PayButtonBloc({@required TransactionRepository transactionRepository, @required TransactionResource transactionResource})
    : assert(transactionRepository != null && transactionResource != null),
      _transactionRepository = transactionRepository,
      super(PayButtonState.initial(transactionResource: transactionResource, isEnabled: _isButtonEnabled(transactionResource: transactionResource)));

  @override
  Stream<PayButtonState> mapEventToState(PayButtonEvent event) async* {
    if (event is TransactionStatusChanged) {
      yield* _mapTransactionChangedToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }
  
  Stream<PayButtonState> _mapTransactionChangedToState(TransactionStatusChanged event) async* {
    yield state.update(
      transactionResource: event.transactionResource,
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
            transactionResource: transactionResource, 
            isSubmitting: false,  
            isSubmitSuccess: true,
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          );
        } else {
          yield state.update(
            transactionResource: transactionResource, 
            isSubmitting: false, 
            isSubmitFailure: true,
            isEnabled: _isButtonEnabled(transactionResource: transactionResource)
          );
        }
      } catch (_) {
        yield state.update(
          transactionResource: state.transactionResource, 
          isSubmitting: false,
          isSubmitFailure: true,
          isSubmitSuccess: false,
          isEnabled: false
        );
      }
    }
  }

  Stream<PayButtonState> _mapResetToState() async* {
    yield state.update(
      isSubmitFailure: false,
      isSubmitSuccess: false,
      isEnabled: _isButtonEnabled(transactionResource: state.transactionResource),
    );
  }

  static bool _isButtonEnabled({@required TransactionResource transactionResource}) {
    List<int> enabledStatusCode = [101, 1020, 1021, 1022, 105, 502];
    return enabledStatusCode.contains(transactionResource.transaction.status.code);
  }
}
