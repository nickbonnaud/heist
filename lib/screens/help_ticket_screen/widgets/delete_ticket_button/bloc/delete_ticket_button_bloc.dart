import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'delete_ticket_button_event.dart';
part 'delete_ticket_button_state.dart';

class DeleteTicketButtonBloc extends Bloc<DeleteTicketButtonEvent, DeleteTicketButtonState> {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;
  
  DeleteTicketButtonBloc({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc,
      super(DeleteTicketButtonState.initial());

  @override
  Stream<DeleteTicketButtonState> mapEventToState(DeleteTicketButtonEvent event) async* {
    if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield state.update(isSuccess: false, isFailure: false);
    }
  }

  Stream<DeleteTicketButtonState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      bool helpTicketDeleted = await _helpRepository.deleteHelpTicket(identifier: event.ticketIdentifier);
      if (helpTicketDeleted) {
        _helpTicketsScreenBloc.add(HelpTicketDeleted(helpTicketIdentifier: event.ticketIdentifier));
        yield state.update(isSubmitting: false, isSuccess: true);
      } else {
        yield state.update(isSubmitting: false, isFailure: true);
      }
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }
}
