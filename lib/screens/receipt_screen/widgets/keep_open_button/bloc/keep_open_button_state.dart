part of 'keep_open_button_bloc.dart';

@immutable
class KeepOpenButtonState {
  final bool isSubmitting;
  final bool isSubmitSuccess;
  final bool isSubmitFailure;

  final TransactionResource transactionResource;

  KeepOpenButtonState({
    @required this.isSubmitting,
    @required this.isSubmitSuccess,
    @required this.isSubmitFailure,
    @required this.transactionResource
  });

  factory KeepOpenButtonState.initial() {
    return KeepOpenButtonState(
      isSubmitting: false,
      isSubmitSuccess: false,
      isSubmitFailure: false,
      transactionResource: null
    );
  }

  KeepOpenButtonState update({
    bool isSubmitting,
    bool isSubmitSuccess,
    bool isSubmitFailure,
    TransactionResource transactionResource
  }) {
    return _copyWith(
      isSubmitting: isSubmitting,
      isSubmitSuccess: isSubmitSuccess,
      isSubmitFailure: isSubmitFailure,
      transactionResource: transactionResource
    );
  }
  
  KeepOpenButtonState _copyWith({
    bool isSubmitting,
    bool isSubmitSuccess,
    bool isSubmitFailure,
    TransactionResource transactionResource
  }) {
    return KeepOpenButtonState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSubmitSuccess: isSubmitSuccess ?? this.isSubmitSuccess,
      isSubmitFailure: isSubmitFailure ?? this.isSubmitFailure,
      transactionResource: transactionResource ?? this.transactionResource
    );
  }

  @override
  String toString() => 'KeepOpenButtonState { isSubmitting: $isSubmitting, isSubmitSuccess: $isSubmitSuccess, isSubmitFailure: $isSubmitFailure, transactionResource: $transactionResource }';
}
