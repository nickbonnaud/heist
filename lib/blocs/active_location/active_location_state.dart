part of 'active_location_bloc.dart';

@immutable
class ActiveLocationState extends Equatable {
  final List<ActiveLocation> activeLocations;
  final List<Beacon> addingLocations;
  final List<Beacon> removingLocations;
  final String errorMessage;

  ActiveLocationState({
    required this.activeLocations,
    required this.addingLocations,
    required this.removingLocations,
    required this.errorMessage
  });

  factory ActiveLocationState.initial() {
    return ActiveLocationState(
      activeLocations: [], 
      addingLocations: [],
      removingLocations: [],
      errorMessage: ""
    );
  }

  ActiveLocationState update({
    List<ActiveLocation>? activeLocations,
    List<Beacon>? addingLocations,
    List<Beacon>? removingLocations,
    String? errorMessage
  }) => ActiveLocationState(
    activeLocations: activeLocations ?? this.activeLocations,
    addingLocations: addingLocations ?? this.addingLocations,
    removingLocations: removingLocations ?? this.removingLocations,
    errorMessage: errorMessage ?? this.errorMessage
  );

  @override
  List<Object> get props => [activeLocations, addingLocations, removingLocations, errorMessage];

  @override
  String toString() => 'ActiveLocationState { activeLocations: $activeLocations, addingLocations: $addingLocations, removingLocations: $removingLocations, errorMessage: $errorMessage }';
}