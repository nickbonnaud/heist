import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'receipt_modal_sheet_event.dart';
part 'receipt_modal_sheet_state.dart';

class ReceiptModalSheetBloc extends Bloc<ReceiptModalSheetEvent, ReceiptModalSheetState> {
  
  ReceiptModalSheetBloc() : super(ReceiptModalSheetState.initial());
  
  @override
  Stream<ReceiptModalSheetState> mapEventToState(ReceiptModalSheetEvent event) async* {
    if (event is Toggle) {
      yield state.update(visible: !state.visible);
    }
  }
}
