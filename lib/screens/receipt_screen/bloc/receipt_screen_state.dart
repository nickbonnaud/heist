part of 'receipt_screen_bloc.dart';

@immutable
class ReceiptScreenState {
  final TransactionResource transactionResource;
  final bool isButtonVisible;

  ReceiptScreenState({@required this.transactionResource, @required this.isButtonVisible});

  factory ReceiptScreenState.initial({@required TransactionResource transactionResource, @required bool isButtonVisible }) {
    return ReceiptScreenState(transactionResource: transactionResource, isButtonVisible: isButtonVisible);
  }

  ReceiptScreenState update({
    TransactionResource transactionResource,
    bool isButtonVisible
  }) {
    return _copyWith(
      transactionResource: transactionResource,
      isButtonVisible: isButtonVisible
    );
  }
  
  ReceiptScreenState _copyWith({
    TransactionResource transactionResource,
    bool isButtonVisible
  }) {
    return ReceiptScreenState(
      transactionResource: transactionResource ?? this.transactionResource,
      isButtonVisible: isButtonVisible ?? this.isButtonVisible
    );
  }
}
