part of 'profile_name_form_bloc.dart';

@immutable
class ProfileNameFormState extends Equatable {
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

  const ProfileNameFormState({
    required this.firstName,
    required this.lastName,

    required this.isFirstNameValid,
    required this.isLastNameValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory ProfileNameFormState.initial() {
    return const ProfileNameFormState(
      firstName: "",
      lastName: "",

      isFirstNameValid: false,
      isLastNameValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  ProfileNameFormState update({
    String? firstName,
    String? lastName,

    bool? isFirstNameValid,
    bool? isLastNameValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => ProfileNameFormState(
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
    return '''ProfileNameFormState {
      firstName: $firstName,
      lastName: $lastName,

      isFirstNameValid: $isFirstNameValid,
      isLastNameValid: $isLastNameValid,
      
      isSubmitting: $isSubmitting,
      errorMessage: $errorMessage,
      isSuccess: $isSuccess
    }''';
  }
}