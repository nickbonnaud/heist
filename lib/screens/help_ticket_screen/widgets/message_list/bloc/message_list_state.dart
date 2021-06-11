part of 'message_list_bloc.dart';

@immutable
class MessageListState {
  final HelpTicket helpTicket;

  HelpTicket get getHelpTicket => helpTicket;
  
  MessageListState({required this.helpTicket});

  factory MessageListState.initial({required HelpTicket helpTicket}) {
    return MessageListState(helpTicket: helpTicket);
  }

  MessageListState update({required HelpTicket helpTicket}) {
    return MessageListState(helpTicket: helpTicket);
  }
  
  @override
  String toString() => 'MessageListState { helpTicket: $helpTicket }';
}
