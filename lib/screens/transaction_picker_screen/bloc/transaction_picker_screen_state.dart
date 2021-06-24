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
  final TransactionResource? transaction;
  final String errorMessage;

  const TransactionsLoaded({
    required this.transactions,
    this.claiming = false,
    this.claimSuccess = false,
    this.transaction,
    this.errorMessage = ""
  });

  TransactionsLoaded update({
    bool? claiming,
    bool? claimSuccess,
    TransactionResource? transaction,
    String? errorMessage
  }) {
    return copyWith(
      claiming: claiming,
      claimSuccess: claimSuccess,
      transaction: transaction,
      errorMessage: errorMessage
    );
  }
  
  TransactionsLoaded copyWith({
    bool? claiming,
    bool? claimSuccess,
    TransactionResource? transaction,
    String? errorMessage
  }) {
    return TransactionsLoaded(
      transactions: this.transactions,
      claiming: claiming ?? this.claiming,
      claimSuccess: claimSuccess ?? this.claimSuccess,
      transaction: transaction ?? this.transaction,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [transactions, claiming, claimSuccess, transaction, errorMessage];

  @override
  String toString() => 'TransactionsLoaded { transactions: $transactions, claiming: $claiming, claimSuccess: $claimSuccess transaction: $transaction, errorMessage: $errorMessage }';
}

class FetchFailure extends TransactionPickerScreenState {
  final String errorMessage;

  const FetchFailure({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => "FetchFailure { errorMessage: $errorMessage }";
}
