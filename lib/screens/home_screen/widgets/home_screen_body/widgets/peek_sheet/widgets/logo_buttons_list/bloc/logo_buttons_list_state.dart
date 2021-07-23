part of 'logo_buttons_list_bloc.dart';

@immutable
class LogoButtonsListState extends Equatable {
  final int numberOpenTransactions;
  final int numberActiveLocations;
  final int numberNearbyLocations;

  LogoButtonsListState({
    required this.numberOpenTransactions,
    required this.numberActiveLocations,
    required this.numberNearbyLocations
  });

  factory LogoButtonsListState.initial({
    required int numberOpenTransactions,
    required int numberActiveLocations,
    required int numberNearbyLocations
  }) {
    return LogoButtonsListState(
      numberOpenTransactions: numberOpenTransactions,
      numberActiveLocations: numberActiveLocations,
      numberNearbyLocations: numberNearbyLocations
    );
  }

  LogoButtonsListState update({
    int? numberOpenTransactions,
    int? numberActiveLocations,
    int? numberNearbyLocations
  }) => LogoButtonsListState(
    numberOpenTransactions: numberOpenTransactions ?? this.numberOpenTransactions,
    numberActiveLocations: numberActiveLocations ?? this.numberActiveLocations,
    numberNearbyLocations: numberNearbyLocations ?? this.numberNearbyLocations
  );

  @override
  List<Object?> get props => [numberOpenTransactions, numberActiveLocations, numberNearbyLocations];

  @override
  String toString() => 'LogoButtonsListState { numberOpenTransactions: $numberOpenTransactions, numberActiveLocations: $numberActiveLocations, numberNearbyLocations: $numberNearbyLocations }';
}
