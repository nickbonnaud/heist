part of 'message_list_bloc.dart';

abstract class MessageListEvent extends Equatable {
  const MessageListEvent();

  @override
  List<Object> get props => [];
}

class ReplyAdded extends MessageListEvent {
  final HelpTicket helpTicket;

  const ReplyAdded({@required this.helpTicket});

  @override
  List<Object> get props => [helpTicket];

  @override
  String toString() => 'ReplyAdded { helpTicket: $helpTicket }';
}

class RepliesViewed extends MessageListEvent {}
