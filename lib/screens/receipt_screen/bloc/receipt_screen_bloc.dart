import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:meta/meta.dart';

part 'receipt_screen_event.dart';
part 'receipt_screen_state.dart';

class ReceiptScreenBloc extends Bloc<ReceiptScreenEvent, ReceiptScreenState> {
  final TransactionResource _transactionResource;

  ReceiptScreenBloc({@required TransactionResource transactionResource})
    : assert(transactionResource != null),
      _transactionResource = transactionResource;
  
  @override
  ReceiptScreenState get initialState => ReceiptScreenState.initial(transactionResource: _transactionResource, isButtonVisible: _isButtonVisible(transactionResource: _transactionResource));

  @override
  Stream<ReceiptScreenState> mapEventToState(ReceiptScreenEvent event) async* {
    if (event is TransactionChanged) {
      yield state.update(transactionResource: event.transactionResource, isButtonVisible: _isButtonVisible(transactionResource: event.transactionResource));
    }
  }

  bool _isButtonVisible({@required TransactionResource transactionResource}) {
    List<int> visibleStatusCodes = [101, 1020, 1021, 1022, 105, 500, 501, 502, 503];
    return visibleStatusCodes.contains(transactionResource.transaction.status.code);
  }
}
