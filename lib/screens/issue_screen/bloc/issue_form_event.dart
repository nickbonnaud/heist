part of 'issue_form_bloc.dart';

abstract class IssueFormEvent extends Equatable {
  const IssueFormEvent();

  @override
  List<Object> get props => [];
}

class MessageChanged extends IssueFormEvent {
  final String message;

  const MessageChanged({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageChanged { message: $message }';
}

class Submitted extends IssueFormEvent {
  final String message;
  final IssueType type;
  final TransactionResource transaction;

  const Submitted({@required this.message, @required this.type, @required this.transaction});

  @override
  List<Object> get props => [message, type, transaction];

  @override
  String toString() => 'Submitted { message: $message, type: $type, transaction: $transaction }';
}

class Reset extends IssueFormEvent {}
