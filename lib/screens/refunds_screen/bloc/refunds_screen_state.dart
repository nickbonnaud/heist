part of 'refunds_screen_bloc.dart';

abstract class RefundsScreenState extends Equatable {
  const RefundsScreenState();

  @override
  List<Object?> get props => [];
}

class Uninitialized extends RefundsScreenState {}

class Loading extends RefundsScreenState {}

class RefundsLoaded extends RefundsScreenState {
  final List<RefundResource> refunds;
  final String? nextUrl;
  final bool paginating;
  final bool hasReachedEnd;
  final Option currentQuery;
  final dynamic queryParams;

  const RefundsLoaded({
    required this.refunds,
    this.nextUrl,
    required this.paginating,
    required this.hasReachedEnd,
    required this.currentQuery,
    required this.queryParams
  });

  RefundsLoaded update({
    List<RefundResource>? refunds,
    String? nextUrl,
    bool? paginating,
    bool? hasReachedEnd,
    Option? currentQuery,
    dynamic queryParams
  }) {
    return RefundsLoaded(
      refunds: refunds ?? this.refunds,
      nextUrl: hasReachedEnd != null && hasReachedEnd ? null : nextUrl ?? this.nextUrl,
      paginating: paginating ?? this.paginating,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentQuery: currentQuery ?? this.currentQuery,
      queryParams: queryParams ?? this.queryParams
    );
  }
  
  @override
  List<Object?> get props => [refunds, nextUrl, paginating, hasReachedEnd, currentQuery, queryParams];

  @override
  String toString() => 'RefundsLoaded { refunds: $refunds, nextUrl: $nextUrl, paginating: $paginating, hasReachedEnd: $hasReachedEnd, currentQuery: $currentQuery, queryParams: $queryParams }';
}

class FetchFailure extends RefundsScreenState {
  final String errorMessage;

  const FetchFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];

  @override
  String toString() => 'FetchFailure { errorMessage: $errorMessage }';
}

