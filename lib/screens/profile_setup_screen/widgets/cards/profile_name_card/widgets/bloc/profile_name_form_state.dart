part of 'profile_name_form_bloc.dart';

@immutable
class ProfileNameFormState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  bool get isFormValid => isFirstNameValid && isLastNameValid;

  ProfileNameFormState({
   required this.isFirstNameValid,
   required this.isLastNameValid,
   required this.isSubmitting,
   required this.isFailure,
   required this.isSuccess
  });

  factory ProfileNameFormState.initial() {
    return ProfileNameFormState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  ProfileNameFormState update({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isSubmitting,
    bool? isFailure,
    bool? isSuccess
  }) => ProfileNameFormState(
    isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
    isLastNameValid: isLastNameValid ?? this.isLastNameValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isFailure: isFailure ?? this.isFailure,
    isSuccess: isSuccess ?? this.isSuccess
  );

  @override
  List<Object?> get props => [isFirstNameValid, isLastNameValid, isSubmitting, isSuccess, isFailure];

  @override
  String toString() {
    return '''ProfileNameFormState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isSubmitting: $isSubmitting,
      isFailure: $isFailure,
      isSuccess: $isSuccess
    }''';
  }
}