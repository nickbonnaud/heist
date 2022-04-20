part of 'help_ticket_form_bloc.dart';

@immutable
class HelpTicketFormState extends Equatable {
  final bool isSubjectValid;
  final bool isMessageValid;
  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => isSubjectValid && isMessageValid;

  const HelpTicketFormState({
    required this.isSubjectValid,
    required this.isMessageValid,
    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory HelpTicketFormState.initial() {
    return const HelpTicketFormState(
      isSubjectValid: false,
      isMessageValid: false,
      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  HelpTicketFormState update({
    bool? isSubjectValid,
    bool? isMessageValid,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => HelpTicketFormState(
    isSubjectValid:  isSubjectValid ?? this.isSubjectValid,
    isMessageValid: isMessageValid ?? this.isMessageValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );
  
  @override
  List<Object> get props => [isSubjectValid, isMessageValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() {
    return '''HelpTicketFormState {
      isSubjectValid: $isSubjectValid,
      isMessageValid: $isMessageValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage
    }''';
  }
}
