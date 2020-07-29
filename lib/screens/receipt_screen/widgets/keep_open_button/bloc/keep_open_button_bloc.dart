import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:meta/meta.dart';

part 'keep_open_button_event.dart';
part 'keep_open_button_state.dart';

class KeepOpenButtonBloc extends Bloc<KeepOpenButtonEvent, KeepOpenButtonState> {
  final TransactionRepository _transactionRepository;

  KeepOpenButtonBloc({@required TransactionRepository transactionRepository})
    : assert(transactionRepository != null),
      _transactionRepository = transactionRepository,
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
          transactionResource: transactionResource
        );
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
