part of 'password_form_bloc.dart';

@immutable
class PasswordFormState {
  final bool isOldPasswordValid;
  final bool isOldPasswordVerified;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;
  final bool isSuccessOldPassword;
  final bool isFailureOldPassword;

  PasswordFormState({
    @required this.isOldPasswordValid,
    @required this.isOldPasswordVerified,
    @required this.isPasswordValid,
    @required this.isPasswordConfirmationValid,
    @required this.isSubmitting,
    @required this.isFailure,
    @required this.isSuccess,
    @required this.isSuccessOldPassword,
    @required this.isFailureOldPassword
  });

  factory PasswordFormState.initial() {
    return PasswordFormState(
      isOldPasswordValid: true,
      isOldPasswordVerified: false, 
      isPasswordValid: true, 
      isPasswordConfirmationValid: true, 
      isSubmitting: false, 
      isFailure: false, 
      isSuccess: false,
      isSuccessOldPassword: false,
      isFailureOldPassword: false
    );
  }

  PasswordFormState update({
    bool isOldPasswordValid,
    bool isOldPasswordVerified,
    bool isPasswordValid,
    bool isPasswordConfirmationValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    bool isSuccessOldPassword,
    bool isFailureOldPassword
  }) {
    return copyWith(
      isOldPasswordValid: isOldPasswordValid,
      isOldPasswordVerified: isOldPasswordVerified,
      isPasswordValid: isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid,
      isSubmitting: isSubmitting,
      isFailure: isFailure,
      isSuccess: isSuccess,
      isSuccessOldPassword: isSuccessOldPassword,
      isFailureOldPassword: isFailureOldPassword
    );
  }
  
  PasswordFormState copyWith({
    bool isOldPasswordValid,
    bool isOldPasswordVerified,
    bool isPasswordValid,
    bool isPasswordConfirmationValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess,
    bool isSuccessOldPassword,
    bool isFailureOldPassword
  }) {
    return PasswordFormState(
      isOldPasswordValid: isOldPasswordValid ?? this.isOldPasswordValid, 
      isOldPasswordVerified: isOldPasswordVerified ?? this.isOldPasswordVerified, 
      isPasswordValid: isPasswordValid ?? this.isPasswordValid, 
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid, 
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isFailure: isFailure ?? this.isFailure, 
      isSuccess: isSuccess ?? this.isSuccess,
      isSuccessOldPassword: isSuccessOldPassword ?? this.isSuccessOldPassword,
      isFailureOldPassword: isFailureOldPassword ?? this.isFailureOldPassword
    );
  }
}
