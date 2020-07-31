part of 'active_location_bloc.dart';

@immutable
class ActiveLocationState {
  final List<ActiveLocation> activeLocations;
  final bool locationFailedToAdd;

  ActiveLocationState({@required this.activeLocations, @required this.locationFailedToAdd});

  factory ActiveLocationState.initial() {
    return ActiveLocationState(activeLocations: <ActiveLocation>[].toList(), locationFailedToAdd: false);
  }

  ActiveLocationState update({
    List<ActiveLocation> activeLocations,
    bool locationFailedToAdd
  }) {
    return _copyWith(
      activeLocations: activeLocations,
      locationFailedToAdd: locationFailedToAdd
    );
  }
  
  ActiveLocationState _copyWith({
    List<ActiveLocation> activeLocations,
    bool locationFailedToAdd
  }) {
    return ActiveLocationState(
      activeLocations:  activeLocations ?? this.activeLocations,
      locationFailedToAdd: locationFailedToAdd ?? this.locationFailedToAdd
    );
  }

  @override
  String toString() => 'ActiveLocationState { activeLocations: $activeLocations, locationFailedToAdd: $locationFailedToAdd }';
}