part of 'help_tickets_screen_bloc.dart';

abstract class HelpTicketsScreenState extends Equatable {
  const HelpTicketsScreenState();
  
  @override
  List<Object?> get props => [];
}

class Uninitialized extends HelpTicketsScreenState {}

class Loading extends HelpTicketsScreenState {}

class Loaded extends HelpTicketsScreenState {
  final List<HelpTicket> helpTickets;
  final String? nextUrl;
  final bool paginating;
  final bool hasReachedEnd;
  final Option currentQuery;
  final dynamic queryParams;

  const Loaded({
    required this.helpTickets,
    this.nextUrl,
    required this.paginating,
    required this.hasReachedEnd,
    required this.currentQuery,
    required this.queryParams
  });

  Loaded copyWith({
    List<HelpTicket>? helpTickets,
    String? nextUrl,
    bool? paginating,
    bool? hasReachedEnd,
    Option? currentQuery,
    dynamic queryParams
  }) {
    return Loaded(
      helpTickets: helpTickets ?? this.helpTickets,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      paginating: paginating ?? this.paginating,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }

  @override
  List<Object?> get props => [helpTickets, nextUrl, paginating, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'Loaded { helpTickets: $helpTickets, nextUrl: $nextUrl, paginating: $paginating, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends HelpTicketsScreenState {
  final String errorMessage;

  const FetchFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'FetchFailure { errorMessage: $errorMessage }';
}
