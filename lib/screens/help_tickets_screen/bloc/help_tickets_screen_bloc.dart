import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:heist/models/help_ticket/help_ticket.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/repositories/help_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';

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
      super(Uninitialized()) { _eventHandler(); }

  bool get paginateEnd {
    final currentState = state;
    return currentState is Loaded && currentState.hasReachedEnd;
  }

  List<HelpTicket> get helpTickets => (state as Loaded).helpTickets;

  void _eventHandler() {
    on<FetchAll>((event, emit) async => await _mapFetchAllToState(event: event, emit: emit));
    on<FetchResolved>((event, emit) async => await _mapFetchResolvedToState(event: event, emit: emit));
    on<FetchOpen>((event, emit) async => await _mapFetchOpenToState(event: event, emit: emit));
    on<HelpTicketUpdated>((event, emit) => _mapHelpTicketUpdatedToState(event: event, emit: emit));
    on<HelpTicketAdded>((event, emit) => _mapHelpTicketAddedToState(event: event, emit: emit));
    on<HelpTicketDeleted>((event, emit) => _mapHelpTicketDeletedToState(event: event, emit: emit));
    on<FetchMore>((event, emit) => _mapFetchMoreToState());
  }

  Future<void> _mapFetchAllToState({required FetchAll event, required Emitter<HelpTicketsScreenState> emit}) async {
    if (event.reset) {
      await _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchAll(), 
        currentQuery: Option.all, 
        queryParams: null,
        emit: emit
      );
    } else {
      final currentState = state;
      if (currentState is Uninitialized) {
         await _fetchUnitialized(
          fetchFunction: () => _helpRepository.fetchAll(), 
          currentQuery: Option.all, 
          queryParams: null,
          emit: emit
        );
      } else if (currentState is Loaded) {
        if (!currentState.paginating) {
          await _fetchMore(
            fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!),
            state: currentState,
            currentQuery: Option.all,
            queryParams: null,
            emit: emit
          );
        }
      }
    }
  }

  Future<void> _mapFetchResolvedToState({required FetchResolved event, required Emitter<HelpTicketsScreenState> emit}) async {
    if (event.reset) {
      await _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchResolved(), 
        currentQuery: Option.resolved,
        queryParams: null,
        emit: emit
      );
    } else {
      final currentState = state;
      if (currentState is Loaded) {
        await _fetchMore(
          fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!), 
          state: currentState,
          currentQuery: Option.resolved, 
          queryParams: null,
          emit: emit
        );
      }
    }
  }

  Future<void> _mapFetchOpenToState({required FetchOpen event, required Emitter<HelpTicketsScreenState> emit}) async {
    if (event.reset) {
      await _fetchUnitialized(
        fetchFunction: () => _helpRepository.fetchOpen(),
        currentQuery: Option.open, 
        queryParams: null,
        emit: emit
      );
    } else {
      final currentState = state;
      if (currentState is Loaded) {
        await _fetchMore(
          fetchFunction: () => _helpRepository.paginate(url: currentState.nextUrl!),
          state: currentState,
          currentQuery: Option.open, 
          queryParams: null,
          emit: emit
        );
      }
    }
  }

  void _mapHelpTicketUpdatedToState({required HelpTicketUpdated event, required Emitter<HelpTicketsScreenState> emit}) {
    if (state is Loaded) {
      final List<HelpTicket> updatedtHelpTickets = (state as Loaded).helpTickets.map((helpTicket) {
        return helpTicket.identifier == event.helpTicket.identifier ? event.helpTicket : helpTicket;
      }).toList();
      emit((state as Loaded).copyWith(helpTickets: updatedtHelpTickets));
    }
  }

  void _mapHelpTicketAddedToState({required HelpTicketAdded event, required Emitter<HelpTicketsScreenState> emit}) {
    if (state is Loaded) {
      final List<HelpTicket> updatedHelpTickets = List.from((state as Loaded).helpTickets)
        ..insert(0, event.helpTicket);
      emit((state as Loaded).copyWith(helpTickets: updatedHelpTickets));
    }
  }

  void _mapHelpTicketDeletedToState({required HelpTicketDeleted event, required Emitter<HelpTicketsScreenState> emit}) {
    if (state is Loaded) {
      final List<HelpTicket> updatedHelpTickets = List.from((state as Loaded).helpTickets.where((helpTicket) => helpTicket.identifier != event.helpTicketIdentifier));
      emit((state as Loaded).copyWith(helpTickets: updatedHelpTickets));
    }
  }

  void _mapFetchMoreToState() {
    final currentState = state;

    if (currentState is Loaded && !currentState.paginating) {
      switch (currentState.currentQuery) {
        case Option.all:
          add(FetchAll(reset: false));
          break;
        case Option.open:
          add(FetchOpen(reset: false));
          break;
        case Option.resolved:
          add(FetchResolved(reset: false));
          break;
      }
    }
  }
  
  Future<void> _fetchUnitialized({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<HelpTicketsScreenState> emit
  }) async {
    try {
      emit(Loading());
      final PaginateDataHolder paginateHolder = await fetchFunction();
      emit(Loaded(
        helpTickets: (paginateHolder.data as List<HelpTicket>),
        paginating: false,
        nextUrl: paginateHolder.next,
        hasReachedEnd: paginateHolder.next == null,
        currentQuery: currentQuery,
        queryParams: queryParams
      ));
    } on ApiException catch(exception) {
      emit(FetchFailure(errorMessage: exception.error));
    }
  }

  Future<void> _fetchMore({
    required Future<PaginateDataHolder>Function() fetchFunction,
    required Loaded state,
    required Option currentQuery,
    required dynamic queryParams,
    required Emitter<HelpTicketsScreenState> emit
  }) async {
    if (!paginateEnd) {
      emit(state.copyWith(paginating: true));
      try {
        final PaginateDataHolder paginateHolder = await fetchFunction();
        emit(Loaded(
          helpTickets: state.helpTickets + (paginateHolder.data as List<HelpTicket>),
          nextUrl: paginateHolder.next,
          paginating: false,
          hasReachedEnd: paginateHolder.next == null, 
          currentQuery: currentQuery,
          queryParams: queryParams
        ));
      } on ApiException catch(exception) {
        emit(FetchFailure(errorMessage: exception.error));
      }
    }
  }
}
