import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

part 'help_ticket_form_event.dart';
part 'help_ticket_form_state.dart';

class HelpTicketFormBloc extends Bloc<HelpTicketFormEvent, HelpTicketFormState> {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;
  
  HelpTicketFormBloc({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc}) 
  : _helpRepository = helpRepository,
    _helpTicketsScreenBloc = helpTicketsScreenBloc,
    super(HelpTicketFormState.initial());

  @override
  Stream<Transition<HelpTicketFormEvent, HelpTicketFormState>> transformEvents(Stream<HelpTicketFormEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) => event is !SubjectChanged && event is !MessageChanged);
    final debounceStream = events.where((event) => event is SubjectChanged || event is MessageChanged)
      .debounceTime(Duration(milliseconds: 300));
    return super.transformEvents(nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }
  
  @override
  Stream<HelpTicketFormState> mapEventToState(HelpTicketFormEvent event) async* {
    if (event is SubjectChanged) {
      yield* _mapSubjectChangedToState(event: event);
    } else if (event is MessageChanged) {
      yield* _mapMessageChangedToState(event: event);
    } else if (event is Submitted) {
      yield* _mapSubmittedToState(event: event);
    } else if (event is Reset) {
      yield* _mapResetToState();
    }
  }

  Stream<HelpTicketFormState> _mapSubjectChangedToState({required SubjectChanged event}) async* {
    yield state.update(isSubjectValid: event.subject.isNotEmpty);
  }

  Stream<HelpTicketFormState> _mapMessageChangedToState({required MessageChanged event}) async* {
    yield state.update(isMessageValid: event.message.isNotEmpty);
  }

  Stream<HelpTicketFormState> _mapSubmittedToState({required Submitted event}) async* {
    yield state.update(isSubmitting: true);

    try {
      HelpTicket helpTicket = await _helpRepository.storeHelpTicket(subject: event.subject, message: event.message);
      _helpTicketsScreenBloc.add(HelpTicketAdded(helpTicket: helpTicket));
      yield state.update(isSubmitting: false, isSuccess: true);
    } catch (_) {
      yield state.update(isSubmitting: false, isFailure: true);
    }
  }
  
  Stream<HelpTicketFormState> _mapResetToState() async* {
    yield state.update(isSuccess: false, isFailure: false);
  }
}
