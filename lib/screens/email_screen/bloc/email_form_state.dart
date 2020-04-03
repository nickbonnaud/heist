part of 'email_form_bloc.dart';

@immutable
class EmailFormState {
  final bool isEmailValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  EmailFormState({
    @required this.isEmailValid,
    @required this.isSubmitting,
    @required this.isFailure,
    @required this.isSuccess
  });

  factory EmailFormState.initial() {
    return EmailFormState(
      isEmailValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  EmailFormState update({
    bool isEmailValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isSubmitting: isSubmitting,
      isFailure: isFailure,
      isSuccess: isSuccess
    );
  }
  
  EmailFormState copyWith({
    bool isEmailValid,
    bool isSubmitting,
    bool isFailure,
    bool isSuccess
  }) {
    return EmailFormState(
      isEmailValid: isEmailValid ?? this.isEmailValid, 
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isFailure: isFailure ?? this.isFailure,
      isSuccess: isSuccess ?? this.isSuccess
    );
  }
}