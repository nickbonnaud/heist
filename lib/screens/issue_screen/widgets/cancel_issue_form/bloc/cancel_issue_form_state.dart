part of 'cancel_issue_form_bloc.dart';

@immutable
class CancelIssueFormState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final TransactionResource transactionResource;
  final String errorMessage;

  const CancelIssueFormState({
    required this.isSubmitting,
    required this.isSuccess,
    required this.transactionResource,
    required this.errorMessage
  });

  factory CancelIssueFormState.initial({required TransactionResource transactionResource}) {
    return CancelIssueFormState(
      isSubmitting: false,
      isSuccess: false,
      transactionResource: transactionResource,
      errorMessage: ""
    );
  }

  CancelIssueFormState update({
    bool? isSubmitting,
    bool? isSuccess,
    TransactionResource? transactionResource,
    String? errorMessage
  }) => CancelIssueFormState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    transactionResource: transactionResource ?? this.transactionResource,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isSubmitting, isSuccess, transactionResource, errorMessage];

  @override
  String toString() => 'CancelIssueFormState { isSubmitting: $isSubmitting, isSuccess: $isSuccess, transactionResource: $transactionResource, errorMessage: $errorMessage }';
}
