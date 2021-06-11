part of 'refunds_screen_bloc.dart';

abstract class RefundsScreenEvent extends Equatable {
  const RefundsScreenEvent();

   @override
  List<Object> get props => [];
}

class FetchAllRefunds extends RefundsScreenEvent {
  final bool reset;

  const FetchAllRefunds({this.reset = false});

  @override
  List<Object> get props => [reset];

  @override
  String toString() => 'FetchAllRefunds { reset: $reset }';
}

class FetchRefundsByDateRange extends RefundsScreenEvent {
  final DateTimeRange dateRange;
  final bool reset;

  const FetchRefundsByDateRange({required this.dateRange, required this.reset});

  @override
  List<Object> get props => [dateRange, reset];

  @override
  String toString() => 'FetchRefundsByDateRange { dateRange: $dateRange, reset: $reset }';
}

class FetchRefundByIdentifier extends RefundsScreenEvent {
  final String identifier;
  final bool reset;

  const FetchRefundByIdentifier({required this.identifier, required this.reset});

  @override
  List<Object> get props => [identifier, reset];

  @override
  String toString() => 'FetchRefundByIdentifier { identifier: $identifier, reset: $reset }';
}

class FetchRefundByBusiness extends RefundsScreenEvent {
  final String identifier;
  final bool reset;

  const FetchRefundByBusiness({required this.identifier, required this.reset});

  @override
  List<Object> get props => [identifier, reset];

  @override
  String toString() => 'FetchRefundByBusiness { identifier: $identifier, reset: $reset }';
}

class FetchRefundByTransaction extends RefundsScreenEvent {
  final String identifier;
  final bool reset;

  const FetchRefundByTransaction({required this.identifier, required this.reset});

  @override
  List<Object> get props => [identifier, reset];

  @override
  String toString() => 'FetchRefundByTransaction { identifier: $identifier, reset: $reset }';
}

class FetchMoreRefunds extends RefundsScreenEvent {}