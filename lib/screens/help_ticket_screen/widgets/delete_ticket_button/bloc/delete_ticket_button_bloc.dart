import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
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
      super(DeleteTicketButtonState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<DeleteTicketButtonState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      bool helpTicketDeleted = await _helpRepository.deleteHelpTicket(identifier: event.ticketIdentifier);
      if (helpTicketDeleted) {
        _helpTicketsScreenBloc.add(HelpTicketDeleted(helpTicketIdentifier: event.ticketIdentifier));
        emit(state.update(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.update(isSubmitting: false, errorMessage: "Unable to remove Help Ticket. Please try again."));
      }
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<DeleteTicketButtonState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
