import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/help_tickets_screen/bloc/help_tickets_screen_bloc.dart';
import 'package:meta/meta.dart';

part 'message_list_event.dart';
part 'message_list_state.dart';

class MessageListBloc extends Bloc<MessageListEvent, MessageListState> {
  final HelpTicketsScreenBloc _helpTicketsScreenBloc;
  final HelpTicket _helpTicket;
  final HelpRepository _helpRepository;

  late StreamSubscription helpTicketsScreenBlocSubscription;
  
  MessageListBloc({required HelpTicket helpTicket, required HelpTicketsScreenBloc helpTicketsScreenBloc, required HelpRepository helpRepository})
    : _helpTicketsScreenBloc = helpTicketsScreenBloc,
      _helpTicket = helpTicket,
      _helpRepository = helpRepository,
      super(MessageListState.initial(helpTicket: helpTicket)) {
    
      helpTicketsScreenBlocSubscription = helpTicketsScreenBloc.stream.listen((HelpTicketsScreenState helpTicketsScreenstate) {
        add(ReplyAdded(
          helpTicket: (helpTicketsScreenstate as Loaded).helpTickets.firstWhere((helpTicket) 
            => helpTicket.identifier == state.helpTicket.identifier)
        ));
      });
  }

  @override
  Stream<MessageListState> mapEventToState(MessageListEvent event) async* {
    if (event is ReplyAdded) {
      yield state.update(helpTicket: event.helpTicket);
    } else if (event is RepliesViewed) {
      yield* _mapRepliesViewedToState();
    }
  }

  Stream<MessageListState> _mapRepliesViewedToState() async* {
    final bool hasUnread = _helpTicket.replies.any((reply) => !reply.fromCustomer && !reply.read);
    if (!_helpTicket.resolved && hasUnread) {
      try {
        final HelpTicket helpTicket = await _helpRepository.updateRepliesAsRead(ticketIdentifier: _helpTicket.identifier);
        _helpTicketsScreenBloc.add(HelpTicketUpdated(helpTicket: helpTicket));
        yield state.update(helpTicket: helpTicket);
      } on ApiException catch(exception) {
        yield state.update(errorMessage: exception.error);
      }
    }
  }

  @override
  Future<void> close() {
    helpTicketsScreenBlocSubscription.cancel();
    return super.close();
  }
}
