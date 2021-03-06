import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'message_input_event.dart';
part 'message_input_state.dart';

class MessageInputBloc extends Bloc<MessageInputEvent, MessageInputState> {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  MessageInputBloc({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc})
    : _helpRepository = helpRepository,
      _helpTicketsScreenBloc = helpTicketsScreenBloc,
      super(MessageInputState.initial());

  @override
  Stream<Transition<MessageInputEvent, MessageInputState>> transformEvents(Stream<MessageInputEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !MessageChanged);
    final debounceStream = events.where((event) => event is MessageChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<MessageInputState> mapEventToState(MessageInputEvent event) async* {
    if (event is MessageChanged) {
      yield* _mapMessageChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<MessageInputState> _mapMessageChangedToState({required MessageChanged event}) async* {
    yield state.update(isInputValid: event.message.trim().isNotEmpty);
  }

  Stream<MessageInputState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);
    try {
      HelpTicket helpTicket = await _helpRepository.storeReply(identifier: event.helpTicketIdentifier, message: event.message);
      _updateHelpTicket(helpTicket: helpTicket);
      yield state.update(isSubmitting: false, isSuccess: true);
    } on ApiException catch (exception) {
      yield state.update(isSubmitting: false, errorMessage: exception.error);
    }
  }

  Stream<MessageInputState> _mapResetToState() async* {
    yield state.update(isSuccess: false, errorMessage: "");
  }

  void _updateHelpTicket({required HelpTicket helpTicket}) {
    _helpTicketsScreenBloc.add(HelpTicketUpdated(helpTicket: helpTicket));
  }
}
