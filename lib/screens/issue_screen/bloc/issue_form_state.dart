part of 'issue_form_bloc.dart';

@immutable
class IssueFormState extends Equatable {
  final TransactionResource transactionResource;
  final IssueType issueType;

  final String message;
  final bool isMessageValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get formValid => isMessageValid && message.isNotEmpty;
  
  const IssueFormState({
    required this.transactionResource,
    required this.issueType,

    required this.message,
    required this.isMessageValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory IssueFormState.initial({required TransactionResource transactionResource, required IssueType issueType}) {
    return IssueFormState(
      transactionResource: transactionResource,
      issueType: issueType,

      message: "",
      isMessageValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  IssueFormState update({
    TransactionResource? transactionResource,

    String? message,
    bool? isMessageValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => IssueFormState(
    transactionResource: transactionResource ?? this.transactionResource,
    issueType: issueType,

    message: message ?? this.message,
    isMessageValid: isMessageValid ?? this.isMessageValid,

    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [transactionResource, issueType, message, isMessageValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'IssueFormState { transactionResource: $transactionResource, issueType: $issueType, message: $message, isMessageValid: $isMessageValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}