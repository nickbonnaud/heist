part of 'receipt_modal_sheet_bloc.dart';

@immutable
class ReceiptModalSheetState {
  final bool visible;

  ReceiptModalSheetState({@required this.visible});

  factory ReceiptModalSheetState.initial() {
    return ReceiptModalSheetState(visible: false);
  }

  ReceiptModalSheetState update({@required bool visible}) {
    return ReceiptModalSheetState(visible: visible);
  }

  @override
  String toString() => 'ReceiptModalSheetState { visible: $visible }';
}
