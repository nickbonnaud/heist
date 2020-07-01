part of 'receipt_modal_sheet_bloc.dart';

abstract class ReceiptModalSheetEvent extends Equatable {
  const ReceiptModalSheetEvent();

  @override
  List<Object> get props => [];
}

class Toggle extends ReceiptModalSheetEvent {}
