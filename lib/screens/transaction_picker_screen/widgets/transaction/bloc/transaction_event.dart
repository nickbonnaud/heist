part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class PickerChanged extends TransactionEvent {
  final DateTime transactionUpdatedAt;

  const PickerChanged({required this.transactionUpdatedAt});

  @override
  List<Object> get props => [transactionUpdatedAt];

  @override
  String toString() => 'PickerChanged { transactionUpdatedAt: $transactionUpdatedAt }';
}
