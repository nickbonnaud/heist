part of 'password_form_bloc.dart';

@immutable
class PasswordFormState extends Equatable {
  final bool isOldPasswordValid;
  final bool isOldPasswordVerified;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isSuccessOldPassword;
  final String errorMessage;

  const PasswordFormState({
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
    return const  PasswordFormState(
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
    bool? isOldPasswordValid,
    bool? isOldPasswordVerified,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isSuccessOldPassword,
    String? errorMessage
  }) => PasswordFormState(
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
