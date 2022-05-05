part of 'email_form_bloc.dart';

@immutable
class EmailFormState extends Equatable {
  final String email;
  final bool isEmailValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isEmailValid && email.isNotEmpty;

  const EmailFormState({
    required this.email,
    required this.isEmailValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory EmailFormState.initial({required String email}) {
    return EmailFormState(
      email: email,
      isEmailValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  EmailFormState update({
    String? email,
    bool? isEmailValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => EmailFormState(
    email: email ?? this.email,
    isEmailValid: isEmailValid ?? this.isEmailValid, 
    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [email, isEmailValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'EmailFormState { email: $email, isEmailValid: $isEmailValid, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}