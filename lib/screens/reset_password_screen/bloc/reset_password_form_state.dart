part of 'reset_password_form_bloc.dart';

@immutable
class ResetPasswordFormState extends Equatable {
  final String email;
  final String resetCode;
  final String password;
  final String passwordConfirmation;

  final bool isResetCodeValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    email.isNotEmpty &&
    isResetCodeValid && resetCode.isNotEmpty &&
    isPasswordValid && password.isNotEmpty &&
    isPasswordConfirmationValid && passwordConfirmation.isNotEmpty;

  const ResetPasswordFormState({
    required this.email,
    required this.resetCode,
    required this.password,
    required this.passwordConfirmation,

    required this.isResetCodeValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory ResetPasswordFormState.initial({required String email}) {
    return ResetPasswordFormState(
      email: email,
      resetCode: "",
      password: "",
      passwordConfirmation: "",

      isResetCodeValid: false,
      isPasswordValid: false,
      isPasswordConfirmationValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ResetPasswordFormState update({
    String? resetCode,
    String? password,
    String? passwordConfirmation,

    bool? isResetCodeValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ResetPasswordFormState(
    email: email,
    resetCode: resetCode ?? this.resetCode,
    password: password ?? this.password,
    passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,

    isResetCodeValid: isResetCodeValid ?? this.isResetCodeValid,
    isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,

    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [
    email,
    resetCode,
    password,
    passwordConfirmation,

    isResetCodeValid,
    isPasswordValid,
    isPasswordConfirmationValid,

    isSubmitting,
    isSuccess,
    errorMessage
  ];

  @override
  String toString() => '''ResetPasswordFormState {
    email: $email,
    resetCode: $resetCode,
    password: $password,
    passwordConfirmation: $passwordConfirmation,

    isResetCodeValid: $isResetCodeValid,
    isPasswordValid: $isPasswordValid,
    isPasswordConfirmationValid: $isPasswordConfirmationValid,
    
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess,
    errorMessage: $errorMessage
  }''';
}
