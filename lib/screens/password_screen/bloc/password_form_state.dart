part of 'password_form_bloc.dart';

@immutable
class PasswordFormState extends Equatable {
  final String oldPassword;
  final String password;
  final String passwordConfirmation;
  
  final bool isOldPasswordValid;
  final bool isOldPasswordVerified;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;

  final bool isSubmitting;
  final bool isSuccess;
  final bool isSuccessOldPassword;
  final String errorMessage;

  bool get oldPasswordFormValid => isOldPasswordValid && oldPassword.isNotEmpty;
  bool get passwordFormValid => isPasswordValid && password.isNotEmpty && isPasswordConfirmationValid && passwordConfirmation.isNotEmpty;

  const PasswordFormState({
    required this.oldPassword,
    required this.password,
    required this.passwordConfirmation,

    required this.isOldPasswordValid,
    required this.isOldPasswordVerified,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.isSuccessOldPassword,
    required this.errorMessage
  });

  factory PasswordFormState.initial() {
    return const PasswordFormState(
      oldPassword: "",
      password: "",
      passwordConfirmation: "",

      isOldPasswordValid: true,
      isOldPasswordVerified: false, 
      isPasswordValid: true, 
      isPasswordConfirmationValid: true, 

      isSubmitting: false, 
      isSuccess: false,
      isSuccessOldPassword: false,
      errorMessage: ""
    );
  }

  PasswordFormState update({
    String? oldPassword,
    String? password,
    String? passwordConfirmation,

    bool? isOldPasswordValid,
    bool? isOldPasswordVerified,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,

    bool? isSubmitting,
    bool? isSuccess,
    bool? isSuccessOldPassword,
    String? errorMessage
  }) => PasswordFormState(
    oldPassword: oldPassword ?? this.oldPassword,
    password: password ?? this.password,
    passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,

    isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid,
    isOldPasswordVerified: isOldPasswordVerified ?? this.isOldPasswordVerified,
    isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,

    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    isSuccessOldPassword: isSuccessOldPassword ?? this.isSuccessOldPassword,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [
    oldPassword,
    password,
    passwordConfirmation,

    isOldPasswordValid,
    isOldPasswordVerified,
    isPasswordValid,
    isPasswordConfirmationValid,

    isSubmitting,
    isSuccess,
    isSuccessOldPassword,
    errorMessage
  ];

  @override
  String toString() => '''PasswordFormState {
    oldPassword: $oldPassword,
    password: $password,
    passwordConfirmation: $passwordConfirmation,

    isOldPasswordValid: $isOldPasswordValid
    isOldPasswordVerified: $isOldPasswordVerified,
    isPasswordValid: $isPasswordValid
    isPasswordConfirmationValid: $isPasswordConfirmationValid,
    
    isSubmitting: $isSubmitting,
    isSuccess: $isSuccess
    isSuccessOldPassword: $isSuccessOldPassword
    errorMessage: $errorMessage
  }''';
}
