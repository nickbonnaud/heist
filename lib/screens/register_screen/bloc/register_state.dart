part of 'register_bloc.dart';

@immutable
class RegisterState {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;

  final Customer customer;

  bool get isFormValid => isEmailValid && isPasswordValid && isPasswordConfirmationValid;

  RegisterState({
    @required this.isEmailValid,
    @required this.isPasswordValid,
    @required this.isPasswordConfirmationValid,
    @required this.isSubmitting,
    @required this.isSuccess,
    @required this.isFailure,
    @required this.customer
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false,
      customer: null
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: true,
      isSuccess: false,
      isFailure: false,
      customer: null
    );
  }

  factory RegisterState.failure() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      isFailure: true,
      customer: null
    );
  }

  factory RegisterState.success({@required Customer customer}) {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: true,
      isFailure: false,
      customer: customer
    );
  }

  RegisterState update({
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordConfirmationValid
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid,
      isSubmitting: false,
      isSuccess: false,
      isFailure: false
    );
  }

  RegisterState copyWith({
    bool isEmailValid,
    bool isPasswordValid,
    bool isPasswordConfirmationValid,
    bool isSubmitEnabled,
    bool isSubmitting,
    bool isSuccess,
    bool isFailure
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      isFailure: isFailure ?? this.isFailure,
      customer: null
    );
  }

  @override
  String toString() {
    return '''RegisterState {
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordConfirmationValid: $isPasswordConfirmationValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      customer: $customer
    }''';
  }
}
