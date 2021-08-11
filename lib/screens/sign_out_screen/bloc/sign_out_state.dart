part of 'sign_out_bloc.dart';

@immutable
class SignOutState extends Equatable {
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  SignOutState({required this.isSubmitting, required this.isSuccess, required this.errorMessage});

  factory SignOutState.initial() {
    return SignOutState(
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  SignOutState update({
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => SignOutState(
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [isSubmitting, isSuccess, errorMessage];

  @override
  String toString() => 'SignOutState { isSubmitting: $isSubmitting, isSuccess: $isSuccess, errorMessage: $errorMessage }';
}
