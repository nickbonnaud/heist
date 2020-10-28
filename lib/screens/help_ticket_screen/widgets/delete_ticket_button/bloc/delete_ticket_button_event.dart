part of 'delete_ticket_button_bloc.dart';

abstract class DeleteTicketButtonEvent extends Equatable {
  const DeleteTicketButtonEvent();

  @override
  List<Object> get props => [];
}

class Submitted extends DeleteTicketButtonEvent {
  final String ticketIdentifier;

  const Submitted({@required this.ticketIdentifier});

  @override
  List<Object> get props => [ticketIdentifier];

  @override
  String toString() => 'Submitted { ticketIdentifier: $ticketIdentifier }';
}

class Reset extends DeleteTicketButtonEvent {}