part of 'logo_buttons_list_bloc.dart';

@immutable
class LogoButtonsListState {
  final int numberOpenTransactions;
  final int numberActiveLocations;
  final int numberNearbyLocations;

  LogoButtonsListState({
    @required this.numberOpenTransactions,
    @required this.numberActiveLocations,
    @required this.numberNearbyLocations
  });

  factory LogoButtonsListState.initial({
    @required int numberOpenTransactions,
    @required int numberActiveLocations,
    @required int numberNearbyLocations
  }) {
    return LogoButtonsListState(
      numberOpenTransactions: numberOpenTransactions,
      numberActiveLocations: numberActiveLocations,
      numberNearbyLocations: numberNearbyLocations
    );
  }

  LogoButtonsListState update({
    int numberOpenTransactions,
    int numberActiveLocations,
    int numberNearbyLocations
  }) {
    return _copyWith(
      numberOpenTransactions: numberOpenTransactions,
      numberActiveLocations: numberActiveLocations,
      numberNearbyLocations: numberNearbyLocations
    );
  }

  LogoButtonsListState _copyWith({
    int numberOpenTransactions,
    int numberActiveLocations,
    int numberNearbyLocations
  }) {
    return LogoButtonsListState(
      numberOpenTransactions: numberOpenTransactions ?? this.numberOpenTransactions,
      numberActiveLocations: numberActiveLocations ?? this.numberActiveLocations,
      numberNearbyLocations: numberNearbyLocations ?? this.numberNearbyLocations
    );
  }

  @override
  String toString() => 'LogoButtonsListState { numberOpenTransactions: $numberOpenTransactions, numberActiveLocations: $numberActiveLocations, numberNearbyLocations: $numberNearbyLocations }';
}
