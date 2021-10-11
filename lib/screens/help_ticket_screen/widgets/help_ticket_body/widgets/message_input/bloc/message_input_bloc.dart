import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'message_input_event.dart';
part 'message_input_state.dart';

class MessageInputBloc extends Bloc<MessageInputEvent, MessageInputState> {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  MessageInputBloc({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc,
      super(MessageInputState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<MessageChanged>((event, emit) => _mapMessageChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: Duration(milliseconds: 300)));
    on<Submitted>((event, emit) async => await _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapMessageChangedToState({required MessageChanged event, required Emitter<MessageInputState> emit}) {
    emit(state.update(isInputValid: event.message.trim().isNotEmpty));
  }

  Future<void> _mapSubmittedToState({required Submitted event, required Emitter<MessageInputState> emit}) async {
    emit(state.update(isSubmitting: true));
    try {
      HelpTicket helpTicket = await _helpRepository.storeReply(identifier: event.helpTicketIdentifier, message: event.message);
      _updateHelpTicket(helpTicket: helpTicket);
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }

  void _mapResetToState({required Emitter<MessageInputState> emit}) {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }

  void _updateHelpTicket({required HelpTicket helpTicket}) {
    _helpTicketsScreenBloc.add(HelpTicketUpdated(helpTicket: helpTicket));
  }
}
