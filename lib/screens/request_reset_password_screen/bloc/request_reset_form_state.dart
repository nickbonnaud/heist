part of 'request_reset_form_bloc.dart';

@immutable
class RequestResetFormState extends Equatable {
  final String email;
  final bool isEmailValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isEmailValid && email.isNotEmpty;

  const RequestResetFormState({
    required this.email,
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory RequestResetFormState.initial() {
    return const RequestResetFormState(
      email: "",
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  RequestResetFormState update({
    String? email,
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => RequestResetFormState(
    email: email ?? this.email,
    isEmailValid: isEmailValid ?? this.isEmailValid, 
    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [email, isEmailValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'RequestResetFormState { email: $email, isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
