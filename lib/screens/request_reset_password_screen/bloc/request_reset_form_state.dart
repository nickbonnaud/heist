part of 'request_reset_form_bloc.dart';

@immutable
class RequestResetFormState extends Equatable {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  const RequestResetFormState({
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory RequestResetFormState.initial() {
    return RequestResetFormState(
      isEmailValid: false,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  RequestResetFormState update({
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => RequestResetFormState(
    isEmailValid: isEmailValid ?? this.isEmailValid, 
    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isEmailValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'RequestResetFormState { isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
