part of 'email_form_bloc.dart';

@immutable
class EmailFormState extends Equatable {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  const EmailFormState({
    required this.isEmailValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory EmailFormState.initial() {
    return EmailFormState(
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  EmailFormState update({
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => EmailFormState(
    isEmailValid: isEmailValid ?? this.isEmailValid, 
    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isEmailValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'EmailFormState { isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}