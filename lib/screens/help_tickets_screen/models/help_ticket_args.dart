import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';

class HelpTicketArgs extends Equatable {
  final HelpTicket helpTicket;
  final HelpTicketsScreenBloc helpTicketsScreenBloc;

  const HelpTicketArgs({required this.helpTicket, required this.helpTicketsScreenBloc});

  @override
  List<Object> get props => [helpTicket, helpTicketsScreenBloc];

  @override
  String toString() => 'HelpTicketArgs { helpTicket: $helpTicket, helpTicketsScreenBloc: $helpTicketsScreenBloc }';
}