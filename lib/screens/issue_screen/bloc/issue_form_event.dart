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

class Submitted extends IssueFormEvent {}

class Updated extends IssueFormEvent {}

class Reset extends IssueFormEvent {}
