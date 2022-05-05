part of 'register_bloc.dart';

@immutable
class RegisterState extends Equatable {
  final String email;
  final String password;
  final String passwordConfirmation;

  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    isEmailValid && email.isNotEmpty &&
    isPasswordValid && password.isNotEmpty &&
    isPasswordConfirmationValid && passwordConfirmation.isNotEmpty;

  const RegisterState({
    required this.email,
    required this.password,
    required this.passwordConfirmation,

    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
  });

  factory RegisterState.empty() {
    return const RegisterState(
      email: "",
      password: "",
      passwordConfirmation: "",

      isEmailValid: false,
      isPasswordValid: false,
      isPasswordConfirmationValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
    );
  }

  RegisterState update({
    String? email,
    String? password,
    String? passwordConfirmation,

    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,

    bool? isSuccess,
    bool? isSubmitting,
    String? errorMessage
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,

      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,

      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    email,
    password,
    passwordConfirmation,

    isEmailValid,
    isPasswordValid,
    isPasswordConfirmationValid,

    isSubmitting,
    isSuccess,
    errorMessage
  ];
  
  @override
  String toString() {
    return '''RegisterState {
      email: $email,
      password: $password,
      passwordConfirmation: $passwordConfirmation,

      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordConfirmationValid: $isPasswordConfirmationValid,

      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
    }''';
  }
}
