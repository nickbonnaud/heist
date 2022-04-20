part of 'message_list_bloc.dart';

@immutable
class MessageListState extends Equatable {
  final HelpTicket helpTicket;
  final String errorMessage;
  
  const MessageListState({required this.helpTicket, required this.errorMessage});

  factory MessageListState.initial({required HelpTicket helpTicket}) {
    return MessageListState(helpTicket: helpTicket, errorMessage: "");
  }

  MessageListState update({HelpTicket? helpTicket, String? errorMessage}) {
    return MessageListState(
      helpTicket: helpTicket ?? this.helpTicket,
      errorMessage: errorMessage ?? this.errorMessage
    );
  }
  
  @override
  List<Object> get props => [helpTicket, errorMessage];
  
  @override
  String toString() => 'MessageListState { helpTicket: $helpTicket, errorMessage: $errorMessage }';
}
