part of 'receipt_screen_bloc.dart';

abstract class ReceiptScreenEvent extends Equatable {
  const ReceiptScreenEvent();
}

class TransactionChanged extends ReceiptScreenEvent {
  final TransactionResource transactionResource;

  const TransactionChanged({@required this.transactionResource});

  @override
  List<Object> get props => [transactionResource];

  @override
  String toString() => 'TransactionChanged { transactionResource: $transactionResource }';
}
