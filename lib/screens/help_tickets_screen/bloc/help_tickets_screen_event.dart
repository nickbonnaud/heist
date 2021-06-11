part of 'help_tickets_screen_bloc.dart';

abstract class HelpTicketsScreenEvent extends Equatable {
  const HelpTicketsScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchAll extends HelpTicketsScreenEvent {
  final bool reset;

  const FetchAll({this.reset = false});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'FetchAll { reset: $reset }';
}

class FetchResolved extends HelpTicketsScreenEvent {
  final bool reset;
  
  const FetchResolved({required this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'FetchResolved { reset: $reset }';
}

class FetchOpen extends HelpTicketsScreenEvent {
  final bool reset;

  const FetchOpen({required this.reset});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'FetchOpen { reset: $reset }';
}

class FetchMore extends HelpTicketsScreenEvent {}

class HelpTicketUpdated extends HelpTicketsScreenEvent {
  final HelpTicket helpTicket;

  const HelpTicketUpdated({required this.helpTicket});
  
  @override
  List<Object> get props => [helpTicket];

  @override
  String toString() => 'HelpTicketUpdated { helpTicket: $helpTicket }';
}

class HelpTicketAdded extends HelpTicketsScreenEvent {
  final HelpTicket helpTicket;

  const HelpTicketAdded({required this.helpTicket});

  @override
  List<Object> get props => [helpTicket];

  @override
  String toString() => 'HelpTicketAdded { helpTicket: $helpTicket }';
}

class HelpTicketDeleted extends HelpTicketsScreenEvent {
  final String helpTicketIdentifier;

  const HelpTicketDeleted({required this.helpTicketIdentifier});

  @override
  List<Object> get props => [helpTicketIdentifier];

  @override
  String toString() => 'HelpTicketDeleted { helpTicketIdentifier: $helpTicketIdentifier }';
}