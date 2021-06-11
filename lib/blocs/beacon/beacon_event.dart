part of 'beacon_bloc.dart';

abstract class BeaconEvent extends Equatable {
  const BeaconEvent();

  @override
  List<Object> get props => [];
}

class StartBeaconMonitoring extends BeaconEvent {
  final List<Business> businesses;

  StartBeaconMonitoring({required this.businesses});

  @override
  List<Object> get props => [businesses];

  @override
  String toString() => 'StartBeaconMonitoring { businesses: $businesses }';
}

class Enter extends BeaconEvent {
  final Region region;

  Enter({required this.region});

  @override
  List<Object> get props => [region];

  @override
  String toString() => 'Enter { region: $region }';
}

class Exit extends BeaconEvent {
  final Region region;

  Exit({required this.region});

  @override
  List<Object> get props => [region];

  @override
  String toString() => 'Exit { region: $region }';
}

class BeaconCancelled extends BeaconEvent {}
