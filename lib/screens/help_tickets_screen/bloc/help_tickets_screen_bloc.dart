import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:meta/meta.dart';

part 'help_tickets_screen_event.dart';
part 'help_tickets_screen_state.dart';

enum Option {
  all,
  resolved,
  open
}

class HelpTicketsScreenBloc extends Bloc<HelpTicketsScreenEvent, HelpTicketsScreenState> {
  final HelpRepository _helpRepository;

  HelpTicketsScreenBloc({required HelpRepository helpRepository})
    : _helpRepository = helpRepository,
      super(Uninitialized());

  bool get paginateEnd {
    final currentState = state;
    return currentState is Loaded && currentState.hasReachedEnd;
  }

  List<HelpTicket> get helpTickets => (state as Loaded).helpTickets;

  @override
  Stream<HelpTicketsScreenState> mapEventToState(HelpTicketsScreenEvent event) async* {
    if (event is FetchAll) {
      yield* _mapFetchAllToState(event: event);
    } else if (event is FetchResolved) {
      yield* _mapFetchResolvedToState(event: event);
    } else if (event is FetchOpen) {
      yield* _mapFetchOpenToState(event: event);
    } else if (event is HelpTicketUpdated) {
      yield* _mapHelpTicketUpdatedToState(event: event);
    } else if (event is HelpTicketAdded) {
      yield* _mapHelpTicketAddedToState(event: event);
    } else if (event is HelpTicketDeleted) {
      yield* _mapHelpTicketDeletedToState(event: event);
    }
  }

  Stream<HelpTicketsScreenState> _mapFetchAllToState({required FetchAll event}) async* {
    if (event.reset) {
      yield* _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchAll(), 
        currentQuery: Option.all, 
        queryParams: null
      );
    } else {
      final currentState = state;
      if (currentState is Uninitialized) {
        yield* _fetchUnitialized(
          fetchFunction: () => _helpRepository.fetchAll(), 
          currentQuery: Option.all, 
          queryParams: null
        );
      } else if (currentState is Loaded) {
        yield* _fetchMore(
          fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!),
          state: currentState,
          currentQuery: Option.all,
          queryParams: null
        );
      }
    }
  }

  Stream<HelpTicketsScreenState> _mapFetchResolvedToState({required FetchResolved event}) async* {
    if (event.reset) {
      yield* _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchResolved(), 
        currentQuery: Option.resolved,
        queryParams: null
      );
    } else {
      final currentState = state;
      if (currentState is Loaded) {
        yield* _fetchMore(
          fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!), 
          state: currentState,
          currentQuery: Option.resolved, 
          queryParams: null
        );
      }
    }
  }

  Stream<HelpTicketsScreenState> _mapFetchOpenToState({required FetchOpen event}) async* {
    if (event.reset) {
      yield* _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchOpen(),
        currentQuery: Option.open, 
        queryParams: null
      );
    } else {
      final currentState = state;
      if (currentState is Loaded) {
        yield* _fetchMore(
          fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!),
          state: currentState,
          currentQuery: Option.open, 
          queryParams: null
        );
      }
    }
  }

  Stream<HelpTicketsScreenState> _mapHelpTicketUpdatedToState({required HelpTicketUpdated event}) async* {
    if (state is Loaded) {
      final List<HelpTicket> updatedtHelpTickets = (state as Loaded).helpTickets.map((helpTicket) {
        return helpTicket.identifier == event.helpTicket.identifier ? event.helpTicket : helpTicket;
      }).toList();
      yield (state as Loaded).copyWith(helpTickets: updatedtHelpTickets);
    }
  }

  Stream<HelpTicketsScreenState> _mapHelpTicketAddedToState({required HelpTicketAdded event}) async* {
    if (state is Loaded) {
      final List<HelpTicket> updatedHelpTickets = List.from((state as Loaded).helpTickets)
        ..insert(0, event.helpTicket);
      yield (state as Loaded).copyWith(helpTickets: updatedHelpTickets);
    }
  }

  Stream<HelpTicketsScreenState> _mapHelpTicketDeletedToState({required HelpTicketDeleted event}) async* {
    if (state is Loaded) {
      final List<HelpTicket> updatedHelpTickets = List.from((state as Loaded).helpTickets.where((helpTicket) => helpTicket.identifier != event.helpTicketIdentifier));
      yield (state as Loaded).copyWith(helpTickets: updatedHelpTickets);
    }
  }

  Stream<HelpTicketsScreenState> _fetchUnitialized({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required Option currentQuery,
    required dynamic queryParams
  }) async* {
    try {
      yield Loading();
      final PaginateDataHolder paginateHolder = await fetchFunction();
      yield Loaded(
        helpTickets: (paginateHolder.data as List<HelpTicket>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      );
    } catch(_) {
      yield FetchFailure();
    }
  }

  Stream<HelpTicketsScreenState> _fetchMore({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required Loaded state,
    required Option currentQuery,
    required dynamic queryParams
  }) async* {
    if (!paginateEnd) {
      yield state.copyWith(paginating: true);
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        yield Loaded(
          helpTickets: state.helpTickets + (paginateHolder.data as List<HelpTicket>),
          nextUrl: paginateHolder.next,
          paginating: false,
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        );
      } catch(_) {
        yield FetchFailure();
      }
    }
  }
}
