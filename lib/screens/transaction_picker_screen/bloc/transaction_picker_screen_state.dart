part of 'transaction_picker_screen_bloc.dart';

abstract class TransactionPickerScreenState extends Equatable {
  const TransactionPickerScreenState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends TransactionPickerScreenState {}

class Loading extends TransactionPickerScreenState {}

class TransactionsLoaded extends TransactionPickerScreenState {
  final List<UnassignedTransactionResource> transactions;
  final bool claiming;
  final bool claimSuccess;
  final bool claimFailure;
  final TransactionResource? transaction;

  const TransactionsLoaded({
    required this.transactions,
    this.claiming = false,
    this.claimSuccess = false,
    this.claimFailure = false,
    this.transaction
  });

  TransactionsLoaded update({
    bool? claiming,
    bool? claimSuccess,
    bool? claimFailure,
    TransactionResource? transaction
  }) {
    return copyWith(
      claiming: claiming,
      claimSuccess: claimSuccess,
      claimFailure: claimFailure,
      transaction: transaction
    );
  }
  
  TransactionsLoaded copyWith({
    bool? claiming,
    bool? claimSuccess,
    bool? claimFailure,
    TransactionResource? transaction
  }) {
    return TransactionsLoaded(
      transactions: this.transactions,
      claiming: claiming ?? this.claiming,
      claimSuccess: claimSuccess ?? this.claimSuccess,
      claimFailure: claimFailure ?? this.claimFailure,
      transaction: transaction ?? this.transaction
    );
  }

  @override
  List<Object?> get props => [transactions, claiming, claimSuccess, claimFailure, transaction];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions, claiming: $claiming, claimSuccess: $claimSuccess, claimFailure: $claimFailure, transaction: $transaction }';
}

class FetchFailure extends TransactionPickerScreenState {}
