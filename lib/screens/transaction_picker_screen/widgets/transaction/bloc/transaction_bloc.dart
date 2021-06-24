import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, DateTime?> {
  TransactionBloc() : super(null);

  @override
  Stream<DateTime> mapEventToState(TransactionEvent event) async* {
    if (event is PickerChanged) {
      yield event.transactionUpdatedAt;
    }
  }
}
