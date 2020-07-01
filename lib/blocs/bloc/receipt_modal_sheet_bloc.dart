import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'receipt_modal_sheet_event.dart';
part 'receipt_modal_sheet_state.dart';

class ReceiptModalSheetBloc extends Bloc<ReceiptModalSheetEvent, ReceiptModalSheetState> {
  @override
  ReceiptModalSheetState get initialState => ReceiptModalSheetState.initial();

  bool get isVisible => state.visible;
  
  @override
  Stream<ReceiptModalSheetState> mapEventToState(ReceiptModalSheetEvent event) async* {
    if (event is Toggle) {
      yield state.update(visible: !state.visible);
    }
  }
}
