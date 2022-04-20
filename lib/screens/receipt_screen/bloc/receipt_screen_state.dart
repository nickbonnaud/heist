part of 'receipt_screen_bloc.dart';

@immutable
class ReceiptScreenState extends Equatable {
  final TransactionResource transactionResource;
  final bool isButtonVisible;

  const ReceiptScreenState({required this.transactionResource, required this.isButtonVisible});

  factory ReceiptScreenState.initial({required TransactionResource transactionResource, required bool isButtonVisible }) {
    return ReceiptScreenState(transactionResource: transactionResource, isButtonVisible: isButtonVisible);
  }

  ReceiptScreenState update({
    TransactionResource? transactionResource,
    bool? isButtonVisible
  }) => ReceiptScreenState(
    transactionResource: transactionResource ?? this.transactionResource,
    isButtonVisible: isButtonVisible ?? this.isButtonVisible
  );

  @override
  List<Object?> get props => [transactionResource, isButtonVisible];

  @override
  String toString() => 'ReceiptScreenState { transactionResource: $transactionResource, isButtonVisible: $isButtonVisible }';
}
