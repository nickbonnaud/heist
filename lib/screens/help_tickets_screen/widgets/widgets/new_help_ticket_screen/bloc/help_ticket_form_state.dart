part of 'help_ticket_form_bloc.dart';

@immutable
class HelpTicketFormState extends Equatable {
  final bool isSubjectValid;
  final bool isMessageValid;
  final bool isSubmitting;
  final bool isFailure;
  final bool isSuccess;

  bool get isFormValid => isSubjectValid && isMessageValid;

  HelpTicketFormState({
    required this.isSubjectValid,
    required this.isMessageValid,
    required this.isSubmitting,
    required this.isFailure,
    required this.isSuccess
  });

  factory HelpTicketFormState.initial() {
    return HelpTicketFormState(
      isSubjectValid: false,
      isMessageValid: false,
      isSubmitting: false,
      isFailure: false,
      isSuccess: false
    );
  }

  HelpTicketFormState update({
    bool? isSubjectValid,
    bool? isMessageValid,
    bool? isSubmitting,
    bool? isFailure,
    bool? isSuccess
  }) => HelpTicketFormState(
    isSubjectValid:  isSubjectValid ?? this.isSubjectValid,
    isMessageValid: isMessageValid ?? this.isMessageValid,
    isSubmitting: isSubmitting ?? this.isSubmitting,
    isFailure: isFailure ?? this.isFailure,
    isSuccess: isSuccess ?? this.isSuccess
  );
  
  @override
  List<Object> get props => [isSubjectValid, isMessageValid, isSubmitting, isSuccess, isFailure];

  @override
  String toString() {
    return '''HelpTicketFormState {
      isSubjectValid: $isSubjectValid,
      isMessageValid: $isMessageValid,
      isSubmitting: $isSubmitting,
      isFailure: $isFailure,
      isSuccess: isSuccess
    }''';
  }
}
