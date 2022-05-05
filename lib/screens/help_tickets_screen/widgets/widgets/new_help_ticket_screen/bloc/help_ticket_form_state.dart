part of 'help_ticket_form_bloc.dart';

@immutable
class HelpTicketFormState extends Equatable {
  final String subject;
  final String message;

  final bool isSubjectValid;
  final bool isMessageValid;

  final bool isSubmitting;
  final bool isSuccess;
  final String errorMessage;

  bool get isFormValid => 
    isSubjectValid && subject.isNotEmpty &&
    isMessageValid && message.isNotEmpty;

  const HelpTicketFormState({
    required this.subject,
    required this.message,

    required this.isSubjectValid,
    required this.isMessageValid,

    required this.isSubmitting,
    required this.isSuccess,
    required this.errorMessage
  });

  factory HelpTicketFormState.initial() {
    return const HelpTicketFormState(
      subject: "",
      message: "",

      isSubjectValid: false,
      isMessageValid: false,

      isSubmitting: false,
      isSuccess: false,
      errorMessage: ""
    );
  }

  HelpTicketFormState update({
    String? subject,
    String? message,

    bool? isSubjectValid,
    bool? isMessageValid,

    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage
  }) => HelpTicketFormState(
    subject: subject ?? this.subject,
    message: message ?? this.message,

    isSubjectValid:  isSubjectValid ?? this.isSubjectValid,
    isMessageValid: isMessageValid ?? this.isMessageValid,

    isSubmitting: isSubmitting ?? this.isSubmitting,
    isSuccess: isSuccess ?? this.isSuccess,
    errorMessage: errorMessage ?? this.errorMessage
  );
  
  @override
  List<Object> get props => [subject, message, isSubjectValid, isMessageValid, isSubmitting, isSuccess, errorMessage];

  @override
  String toString() {
    return '''HelpTicketFormState {
      subject: $subject,
      message: $message,
      isSubjectValid: $isSubjectValid,
      isMessageValid: $isMessageValid,
      isSubmitting: $isSubmitting,
      isSuccess: $isSuccess,
      errorMessage: $errorMessage
    }''';
  }
}
