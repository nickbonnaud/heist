part of 'transaction_picker_screen_bloc.dart';

@immutable
class TransactionPickerScreenState extends Equatable {
  final bool loading;
  final List<UnassignedTransactionResource> transactions;
  final bool claiming;
  final bool claimSuccess;
  final TransactionResource? transaction;
  final String errorMessage;

  const TransactionPickerScreenState({
    required this.loading,
    required this.transactions,
    required this.claiming,
    required this.claimSuccess,
    required this.transaction,
    required this.errorMessage
  });

  factory TransactionPickerScreenState.initial() {
    return const TransactionPickerScreenState(
      loading: false,
      transactions: [],
      claiming: false,
      claimSuccess: false,
      transaction: null,
      errorMessage: ""
    );
  }

  TransactionPickerScreenState update({
    bool? loading,
    List<UnassignedTransactionResource>? transactions,
    bool? claiming,
    bool? claimSuccess,
    TransactionResource? transaction,
    String? errorMessage
  }) => TransactionPickerScreenState(
    loading: loading ?? this.loading,
    transactions: transactions ?? this.transactions,
    claiming: claiming ?? this.claiming,
    claimSuccess: claimSuccess ?? this.claimSuccess,
    transaction: transaction ?? this.transaction,
    errorMessage: errorMessage ?? this.errorMessage
  );
  
  @override
  List<Object?> get props => [
    loading,
    transactions,
    claiming,
    claimSuccess,
    transaction,
    errorMessage
  ];

  @override
  String toString() {
    return '''TransactionPickerScreenState {
      loading: $loading
      transactions: $transactions,
      claiming: $claiming
      claimSuccess: $claimSuccess,
      transaction: $transaction,
      errorMessage: $errorMessage
    }''';
  }
}
