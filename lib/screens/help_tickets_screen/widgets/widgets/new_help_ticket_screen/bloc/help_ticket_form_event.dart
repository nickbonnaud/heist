part of 'help_ticket_form_bloc.dart';

abstract class HelpTicketFormEvent extends Equatable {
  const HelpTicketFormEvent();

  @override
  List<Object> get props => [];
}

class SubjectChanged extends HelpTicketFormEvent {
  final String subject;

  const SubjectChanged({required this.subject});

  @override
  List<Object> get props => [subject];

  @override
  String toString() => 'SubjectChanged { subject: $subject }';
}

class MessageChanged extends HelpTicketFormEvent {
  final String message;

  const MessageChanged({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageChanged { message: $message }';
}

class Submitted extends HelpTicketFormEvent {
  final String subject;
  final String message;

  const Submitted({required this.subject, required this.message});

  @override
  List<Object> get props => [subject, message];

  @override
  String toString() => 'Submitted { subjectL $subject, messageL $message }';
}

class Reset extends HelpTicketFormEvent {}
