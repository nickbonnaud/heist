part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class PickerChanged extends TransactionEvent {
  final UnassignedTransactionResource transactionResource;

  const PickerChanged({@required this.transactionResource});

  @override
  List<Object> get props => [transactionResource];

  @override
  String toString() => 'PickerChanged { transactionResource: $transactionResource }';
}
