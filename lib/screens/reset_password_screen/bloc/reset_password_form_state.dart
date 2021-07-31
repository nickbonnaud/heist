part of 'reset_password_form_bloc.dart';

@immutable
class ResetPasswordFormState extends Equatable {
  final bool isResetCodeValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final String email;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get fieldsValid => isResetCodeValid && isPasswordValid && isPasswordConfirmationValid;

  const ResetPasswordFormState({
    required this.isResetCodeValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,
    required this.email,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory ResetPasswordFormState.initial({required String email}) {
    return ResetPasswordFormState(
      isResetCodeValid: false,
      isPasswordValid: false,
      isPasswordConfirmationValid: false,
      email: email,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ResetPasswordFormState update({
    bool? isResetCodeValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ResetPasswordFormState(
    isResetCodeValid: isResetCodeValid ?? this.isResetCodeValid,
    isPasswordValid: isPasswordValid ?? this.isPasswordValid,
    isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
    email: this.email,
    isSubmitting: isSubmitting ?? this.isSubmitting, 
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isResetCodeValid, isPasswordValid, isPasswordConfirmationValid, email, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'ResetPasswordFormState { isResetCodeValid: $isResetCodeValid, isPasswordValid: $isPasswordValid, isPasswordConfirmationValid: $isPasswordConfirmationValid,  email: $email, isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
