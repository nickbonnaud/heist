part of 'login_bloc.dart';

@immutable
class LoginState extends Equatable {
  final String email;
  final String password;

  final bool isEmailValid;
  final bool isPasswordValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    isEmailValid && email.isNotEmpty &&
    isPasswordValid && password.isNotEmpty;

  const LoginState({
    required this.email,
    required this.password,

    required this.isEmailValid,
    required this.isPasswordValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory LoginState.empty() {
    return const LoginState(
      email: "",
      password: "",
      
      isEmailValid: false,
      isPasswordValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  LoginState update({
    String? email,
    String? password,

    bool? isEmailValid,
    bool? isPasswordValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) {
    return copyWith(
      email: email,
      password: password,

      isEmailValid: isEmailValid,
      isPasswordValid: isPasswordValid,

      isSubmitting: isSubmitting,
      isSuccess: isSuccess,
      errorMessage: errorMessage
    );
  }

  LoginState copyWith({
    String? email,
    String? password,

    bool? isEmailValid,
    bool? isPasswordValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,

      isEmailValid: isEmailValid ?? this.isEmailValid,
      isPasswordValid: isPasswordValid ?? this.isPasswordValid,
      
      isSubmitting: isSubmitting ?? this.isSubmitting, 
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }

  @override
  List<Object?> get props => [email, password, isEmailValid, isPasswordValid, isSubmitting, isSuccess, errorMessage];
  
  @override
  String toString() {
    return '''LoginState {
      email: $email,
      password: $password,

      isEmailValid: $isEmailValid,
      isPasswordValid: $isPasswordValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage
    } ''';
  }
}