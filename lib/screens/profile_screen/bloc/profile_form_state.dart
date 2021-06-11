part of 'profile_form_bloc.dart';

@immutable
class ProfileFormState extends Equatable {
  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  bool get isFormValid => isFirstNameValid && isLastNameValid;

  ProfileFormState({
   required this.isFirstNameValid,
   required this.isLastNameValid,
   required this.isSubmitting,
   required this.isFailure,
   required this.isSuccess
  });

  factory ProfileFormState.initial() {
    return ProfileFormState(
      isFirstNameValid: true,
      isLastNameValid: true,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  ProfileFormState update({
    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isSubmitting,
    bool? isFailure,
    bool? isSuccess
  }) => ProfileFormState(
    isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
    isLastNameValid: isLastNameValid ?? this.isLastNameValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isFailure: isFailure ?? this.isFailure,
    isSuccess: isSuccess ?? this.isSuccess
  );

  @override
  List<Object?> get props => [isFirstNameValid, isLastNameValid, isSubmitting, isFailure, isSuccess];

  @override
  String toString() {
    return '''ProfileFormState {
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isSubmitting: $isSubmitting,
      isFailure: $isFailure,
      isSuccess: $isSuccess
    }''';
  }
}
