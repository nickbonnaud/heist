part of 'profile_name_form_bloc.dart';

@immutable
class ProfileNameFormState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;
  bool get isFormValid => isFirstNameValid && isLastNameValid;

  ProfileNameFormState({
   required this.isFirstNameValid,
   required this.isLastNameValid,
   required this.isSubmitting,
   required this.isSuccess,
   required this.errorMessage
  });

  factory ProfileNameFormState.initial() {
    return ProfileNameFormState(
      isFirstNameValid: false,
      isLastNameValid: false,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ProfileNameFormState update({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ProfileNameFormState(
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
    return '''ProfileNameFormState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isSubmitting: $isSubmitting,
      errorMessage: $errorMessage,
      isSuccess: $isSuccess
    }''';
  }
}