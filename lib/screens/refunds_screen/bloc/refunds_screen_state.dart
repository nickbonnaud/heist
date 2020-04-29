part of 'refunds_screen_bloc.dart';

abstract class RefundsScreenState extends Equatable {
  const RefundsScreenState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends RefundsScreenState {}

class Loading extends RefundsScreenState {}

class RefundsLoaded extends RefundsScreenState {
  final List<RefundResource> refunds;
  final int nextPage;
  final bool hasReachedEnd;
  final Options currentQuery;
  final dynamic queryParams;

  const RefundsLoaded({@required this.refunds, @required this.nextPage, @required this.hasReachedEnd, @required this.currentQuery, @required this.queryParams});

  RefundsLoaded copyWith({
    List<RefundResource> refunds,
    int nextPage,
    bool hasReachedEnd,
    Options currentQuery,
    dynamic queryParams
  }) {
    return RefundsLoaded(
      refunds: refunds ?? this.refunds,
      nextPage: nextPage ?? this.nextPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }
  
  @override
  List<Object> get props => [refunds, nextPage, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'RefundsLoaded { refunds: $refunds, nextPage: $nextPage, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends RefundsScreenState {}

