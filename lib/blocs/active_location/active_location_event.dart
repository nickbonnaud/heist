part of 'active_location_bloc.dart';

abstract class ActiveLocationEvent extends Equatable {
  const ActiveLocationEvent();

  @override
  List<Object> get props => [];
}

class NewActiveLocation extends ActiveLocationEvent {
  final String beaconIdentifier;

  NewActiveLocation({required this.beaconIdentifier});

  @override
  List<Object> get props => [beaconIdentifier];

  @override
  String toString() => 'NewActiveLocation { beaconIdentifier: $beaconIdentifier }';
}

class RemoveActiveLocation extends ActiveLocationEvent {
  final String beaconIdentifier;

  RemoveActiveLocation({required this.beaconIdentifier});

  @override
  List<Object> get props => [beaconIdentifier];

  @override
  String toString() => 'RemoveActiveLocation { beaconIdentifier: $beaconIdentifier }';
}

class ResetActiveLocations extends ActiveLocationEvent {}
