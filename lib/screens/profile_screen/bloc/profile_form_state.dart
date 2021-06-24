part of 'profile_form_bloc.dart';

@immutable
class ProfileFormState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isFirstNameValid && isLastNameValid;

  ProfileFormState({
    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory ProfileFormState.initial() {
    return ProfileFormState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ProfileFormState update({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ProfileFormState(
    isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
    isLastNameValid: isLastNameValid ?? this.isLastNameValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [isFirstNameValid, isLastNameValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() {
    return '''ProfileFormState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: errorMessage
    }''';
  }
}
