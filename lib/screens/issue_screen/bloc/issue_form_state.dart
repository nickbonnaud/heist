part of 'issue_form_bloc.dart';

@immutable
class IssueFormState extends Equatable {
  final bool isMessageValid;
  final bool isSubmitting;
  final bool isSuccess;
  final TransactionResource transactionResource;
  final String errorMessage;

  const IssueFormState({
    required this.isMessageValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.transactionResource,
    required this.errorMessage
  });

  factory IssueFormState.initial({required TransactionResource transactionResource}) {
    return IssueFormState(
      isMessageValid: true,
      isSubmitting: false,
      isSuccess: false,
      transactionResource: transactionResource,
      errorMessage: ""
    );
  }

  IssueFormState update({
    bool? isMessageValid,
    bool? isSubmitting,
    bool? isSuccess,
    TransactionResource? transactionResource,
    String? errorMessage
  }) => IssueFormState(
    isMessageValid: isMessageValid ?? this.isMessageValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    transactionResource: transactionResource ?? this.transactionResource,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [isMessageValid, isSubmitting, isSuccess, transactionResource, errorMessage];

  @override
  String toString() => 'IssueFormState { isMessageValid: $isMessageValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, transactionResource: $transactionResource, errorMessage: $errorMessage }';
}