part of 'cancel_issue_form_bloc.dart';

@immutable
class CancelIssueFormState extends Equatable {
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;
  final TransactionResource transactionResource;

  CancelIssueFormState({
    required this.isSubmitting,
    required this.isFailure,
    required this.isSuccess,
    required this.transactionResource
  });

  factory CancelIssueFormState.initial({required TransactionResource transactionResource}) {
    return CancelIssueFormState(
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
      transactionResource: transactionResource
    );
  }

  CancelIssueFormState update({
    bool? isSubmitting,
    bool? isFailure,
    bool? isSuccess,
    TransactionResource? transactionResource
  }) => CancelIssueFormState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isFailure: isFailure ?? this.isFailure,
    isSuccess: isSuccess ?? this.isSuccess,
    transactionResource: transactionResource ?? this.transactionResource
  );

  @override
  List<Object> get props => [isSubmitting, isFailure, isSuccess, transactionResource];

  @override
  String toString() => 'CancelIssueFormState { isSubmitting: $isSubmitting, isFailure: $isFailure, isSuccess: $isSuccess, transactionResource: $transactionResource }';
}
