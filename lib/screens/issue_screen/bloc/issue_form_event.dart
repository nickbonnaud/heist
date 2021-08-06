part of 'issue_form_bloc.dart';

abstract class IssueFormEvent extends Equatable {
  const IssueFormEvent();

  @override
  List<Object> get props => [];
}

class MessageChanged extends IssueFormEvent {
  final String message;

  const MessageChanged({required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageChanged { message: $message }';
}

class Submitted extends IssueFormEvent {
  final String message;
  final IssueType type;
  final String transactionIdentifier;

  const Submitted({required this.message, required this.type, required this.transactionIdentifier});

  @override
  List<Object> get props => [message, type, transactionIdentifier];

  @override
  String toString() => 'Submitted { message: $message, type: $type, transactionIdentifier: $transactionIdentifier }';
}

class Updated extends IssueFormEvent {
  final String message;
  final IssueType type;
  final String issueIdentifier;

  const Updated({required this.message, required this.type, required this.issueIdentifier});

  @override
  List<Object> get props => [message, type, issueIdentifier];

  @override
  String toString() => 'Updated { message: $message, type: $type, issueIdentifier: $issueIdentifier }';
}

class Reset extends IssueFormEvent {}
