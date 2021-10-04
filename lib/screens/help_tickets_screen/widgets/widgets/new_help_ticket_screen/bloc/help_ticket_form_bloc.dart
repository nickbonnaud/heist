import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/resources/helpers/debouncer.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'help_ticket_form_event.dart';
part 'help_ticket_form_state.dart';

class HelpTicketFormBloc extends Bloc<HelpTicketFormEvent, HelpTicketFormState> {
  final HelpRepository _helpRepository;
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;

  final Duration debounceTime = Duration(milliseconds: 300);
  
  HelpTicketFormBloc({required HelpRepository helpRepository, required HelpTicketsScreenBloc helpTicketsScreenBloc}) 
  : _helpRepository = helpRepository,
    _helpTicketsScreenBloc = helpTicketsScreenBloc,
    super(HelpTicketFormState.initial()) { _eventHandler(); }

  void _eventHandler() {
    on<SubjectChanged>((event, emit) => _mapSubjectChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: debounceTime));
    on<MessageChanged>((event, emit) => _mapMessageChangedToState(event: event, emit: emit), transformer: Debouncer.bounce(duration: debounceTime));
    on<Submitted>((event, emit) => _mapSubmittedToState(event: event, emit: emit));
    on<Reset>((event, emit) => _mapResetToState(emit: emit));
  }

  void _mapSubjectChangedToState({required SubjectChanged event, required Emitter<HelpTicketFormState> emit}) async {
    emit(state.update(isSubjectValid: event.subject.trim().isNotEmpty));
  }

  void _mapMessageChangedToState({required MessageChanged event, required Emitter<HelpTicketFormState> emit}) async {
    emit(state.update(isMessageValid: event.message.trim().isNotEmpty));
  }

  void _mapSubmittedToState({required Submitted event, required Emitter<HelpTicketFormState> emit}) async {
    emit(state.update(isSubmitting: true));

    try {
      HelpTicket helpTicket = await _helpRepository.storeHelpTicket(subject: event.subject, message: event.message);
      _helpTicketsScreenBloc.add(HelpTicketAdded(helpTicket: helpTicket));
      emit(state.update(isSubmitting: false, isSuccess: true));
    } on ApiException catch (exception) {
      emit(state.update(isSubmitting: false, errorMessage: exception.error));
    }
  }
  
  void _mapResetToState({required Emitter<HelpTicketFormState> emit}) async {
    emit(state.update(isSuccess: false, errorMessage: ""));
  }
}
