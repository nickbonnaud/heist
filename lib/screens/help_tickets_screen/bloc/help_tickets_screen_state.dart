part of 'help_tickets_screen_bloc.dart';

abstract class HelpTicketsScreenState extends Equatable {
  const HelpTicketsScreenState();
  
  @override
  List<Object> get props => [];
}

class Uninitialized extends HelpTicketsScreenState {}

class Loading extends HelpTicketsScreenState {}

class Loaded extends HelpTicketsScreenState {
  final List<HelpTicket> helpTickets;
  final int nextPage;
  final bool hasReachedEnd;
  final Option currentQuery;
  final dynamic queryParams;

  const Loaded({
    @required this.helpTickets,
    @required this.nextPage,
    @required this.hasReachedEnd,
    @required this.currentQuery,
    @required this.queryParams
  });

  Loaded copyWith({
    List<HelpTicket> helpTickets,
    int nextPage,
    bool hasReachedEnd,
    Option currentQuery,
    dynamic queryParams
  }) {
    return Loaded(
      helpTickets: helpTickets ?? this.helpTickets,
      nextPage: nextPage ?? this.nextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }

  @override
  List<Object> get props => [helpTickets, nextPage, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'Loaded { helpTickets: $helpTickets, nextPage: $nextPage, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends HelpTicketsScreenState {}
