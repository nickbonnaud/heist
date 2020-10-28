part of 'message_input_bloc.dart';

abstract class MessageInputEvent extends Equatable {
  const MessageInputEvent();

  @override
  List<Object> get props => [];
}

class MessageChanged extends MessageInputEvent {
  final String message;

  const MessageChanged({@required this.message});

  @override
  List<Object> get props => [message];

  @override
  String toString() => 'MessageChanged { message: $message }';
}

class Submitted extends MessageInputEvent {
  final String helpTicketIdentifier;
  final String message;

  const Submitted({@required this.message, @required this.helpTicketIdentifier});

  @override
  List<Object> get props => [message, helpTicketIdentifier];

  @override
  String toString() => 'Submitted { message: $message, helpTicketIdentifier: $helpTicketIdentifier }';
}

class Reset extends MessageInputEvent {}
