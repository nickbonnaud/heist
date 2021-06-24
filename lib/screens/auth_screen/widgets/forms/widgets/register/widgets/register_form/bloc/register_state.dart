part of 'register_bloc.dart';

@immutable
class RegisterState extends Equatable {
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isPasswordConfirmationValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isEmailValid && isPasswordValid && isPasswordConfirmationValid;

  RegisterState({
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isPasswordConfirmationValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage,
  });

  factory RegisterState.empty() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: "",
    );
  }

  factory RegisterState.loading() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: true,
      isSuccess: false,
      errorMessage: "",
    );
  }

  factory RegisterState.failure({required String errorMessage}) {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }

  factory RegisterState.success() {
    return RegisterState(
      isEmailValid: true,
      isPasswordValid: true,
      isPasswordConfirmationValid: true,
      isSubmitting: false,
      isSuccess: true,
      errorMessage: "",
    );
  }

  RegisterState update({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid
  }) {
    return copyWith(
      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid
    );
  }

  RegisterState copyWith({
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isPasswordConfirmationValid,
  }) {
    return RegisterState(
      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      isPasswordConfirmationValid: isPasswordConfirmationValid ?? this.isPasswordConfirmationValid,
      isSubmitting: this.isSubmitting,
      isSuccess: this.isSuccess,
      errorMessage: this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
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
      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isPasswordConfirmationValid: $isPasswordConfirmationValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage,
    }''';
  }
}
