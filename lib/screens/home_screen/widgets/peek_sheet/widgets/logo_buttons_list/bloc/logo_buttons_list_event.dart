part of 'logo_buttons_list_bloc.dart';

abstract class LogoButtonsListEvent extends Equatable {
  const LogoButtonsListEvent();
}

class NumberOpenTransactionsChanged extends LogoButtonsListEvent {
  final int numberOpenTransactions;

  const NumberOpenTransactionsChanged({@required this.numberOpenTransactions});

  @override
  List<Object> get props => [numberOpenTransactions];

  @override
  String toString() => 'NumberOpenTransactionsChanged { numberOpenTransactions: $numberOpenTransactions }';
}

class NumberActiveLocationsChanged extends LogoButtonsListEvent {
  final int numberActiveLocations;

  const NumberActiveLocationsChanged({@required this.numberActiveLocations});

  @override
  List<Object> get props => [numberActiveLocations];

  @override
  String toString() => 'NumberActiveLocationsChanged { numberActiveLocations: $numberActiveLocations }';
}

class NumberNearbyBusinessesChanged extends LogoButtonsListEvent {
  final int numberNearbyBusinesses;

  const NumberNearbyBusinessesChanged({@required this.numberNearbyBusinesses});

  @override
  List<Object> get props => [numberNearbyBusinesses];

  @override
  String toString() => 'NumberNearbyBusinessesChanged { numberNearbyBusinesses: $numberNearbyBusinesses }';
}