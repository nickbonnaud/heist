import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'receipt_modal_sheet_event.dart';
part 'receipt_modal_sheet_state.dart';

class ReceiptModalSheetBloc extends Bloc<ReceiptModalSheetEvent, ReceiptModalSheetState> {
  
  ReceiptModalSheetBloc()
    : super(ReceiptModalSheetState.initial()) { _eventHandler(); }

  bool get isVisible => state.visible;
  
  void _eventHandler() {
    on<Toggle>((event, emit) => _mapToggleToState(emit: emit));
  }

  void _mapToggleToState({required Emitter<ReceiptModalSheetState> emit}) async {
    emit(state.update(visible: !state.visible));
  }
}
