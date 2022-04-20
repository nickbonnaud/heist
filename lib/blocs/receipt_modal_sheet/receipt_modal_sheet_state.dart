part of 'receipt_modal_sheet_bloc.dart';

@immutable
class ReceiptModalSheetState extends Equatable {
  final bool visible;

  const ReceiptModalSheetState({required this.visible});

  factory ReceiptModalSheetState.initial() {
    return const ReceiptModalSheetState(visible: false);
  }

  ReceiptModalSheetState update({required bool visible}) {
    return ReceiptModalSheetState(visible: visible);
  }

  @override
  List<Object> get props => [visible];

  @override
  String toString() => 'ReceiptModalSheetState { visible: $visible }';
}
