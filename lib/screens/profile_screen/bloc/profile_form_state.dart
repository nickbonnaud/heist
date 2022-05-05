part of 'profile_form_bloc.dart';

@immutable
class ProfileFormState extends Equatable {
  final String firstName;
  final String lastName;

  final bool isFirstNameValid;
  final bool isLastNameValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    isFirstNameValid && firstName.isNotEmpty &&
    isLastNameValid && lastName.isNotEmpty;

  const ProfileFormState({
    required this.firstName,
    required this.lastName,

    required this.isFirstNameValid,
    required this.isLastNameValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory ProfileFormState.initial({required Profile profile}) {
    return ProfileFormState(
      firstName: profile.firstName,
      lastName: profile.lastName,

      isFirstNameValid: true,
      isLastNameValid: true,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ProfileFormState update({
    String? firstName,
    String? lastName,

    bool? isFirstNameValid,
    bool? isLastNameValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ProfileFormState(
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,

    isFirstNameValid: isFirstNameValid ?? this.isFirstNameValid,
    isLastNameValid: isLastNameValid ?? this.isLastNameValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object?> get props => [firstName, lastName, isFirstNameValid, isLastNameValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() {
    return '''ProfileFormState {
      firstName: $firstName,
      lastName: $lastName,
      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: errorMessage
    }''';
  }
}
