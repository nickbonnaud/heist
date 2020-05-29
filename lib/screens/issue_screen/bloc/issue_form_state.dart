part of 'issue_form_bloc.dart';

@immutable
class IssueFormState {
  final bool isMessageValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;
  final TransactionResource transactionResource;

  IssueFormState({
    @required this.isMessageValid,
    @required this.isSubmitting,
    @required this.isFailure,
    @required this.isSuccess,
    @required this.transactionResource
  });

  factory IssueFormState.initial({@required TransactionResource transactionResource}) {
    return IssueFormState(
      isMessageValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false,
      transactionResource: transactionResource
    );
  }

  IssueFormState update({
    bool isMessageValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    TransactionResource transactionResource
  }) {
    return _copyWith(
      isMessageValid: isMessageValid,
      isSubmitting: isSubmitting,
      isFailure: isFailure,
      isSuccess: isSuccess,
      transactionResource: transactionResource
    );
  }
  
  IssueFormState _copyWith({
    bool isMessageValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    TransactionResource transactionResource
  }) {
    return IssueFormState(
      isMessageValid: isMessageValid ?? this.isMessageValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess,
      transactionResource: transactionResource ?? this.transactionResource
    );
  }
}