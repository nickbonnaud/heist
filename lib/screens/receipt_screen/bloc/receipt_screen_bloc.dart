import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:meta/meta.dart';

part 'receipt_screen_event.dart';
part 'receipt_screen_state.dart';

class ReceiptScreenBloc extends Bloc<ReceiptScreenEvent, ReceiptScreenState> {

  ReceiptScreenBloc({required TransactionResource transactionResource})
    : super(ReceiptScreenState.initial(transactionResource: transactionResource, isButtonVisible: _isButtonVisible(transactionResource: transactionResource)));

  @override
  Stream<ReceiptScreenState> mapEventToState(ReceiptScreenEvent event) async* {
    if (event is TransactionChanged) {
      yield state.update(transactionResource: event.transactionResource, isButtonVisible: _isButtonVisible(transactionResource: event.transactionResource));
    }
  }

  static bool _isButtonVisible({required TransactionResource transactionResource}) {
    List<int> visibleStatusCodes = [101, 1020, 1021, 1022, 105, 500, 501, 502, 503];
    return visibleStatusCodes.contains(transactionResource.transaction.status.code);
  }
}
