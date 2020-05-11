import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/unassigned_transaction/unassigned_transaction_resource.dart';
import 'package:meta/meta.dart';

part 'transaction_event.dart';

class TransactionBloc extends Bloc<TransactionEvent, String> {
  
  @override
  String get initialState => '';

  @override
  Stream<String> mapEventToState(TransactionEvent event) async* {
    if (event is PickerChanged) {
      yield event.transactionResource.transaction.updatedDate;
    }
  }
}
