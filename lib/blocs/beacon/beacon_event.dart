part of 'beacon_bloc.dart';

abstract class BeaconEvent extends Equatable {
  const BeaconEvent();

  @override
  List<Object> get props => [];
}

class StartBeaconMonitoring extends BeaconEvent {
  final List<Business> businesses;

  const StartBeaconMonitoring({required this.businesses});

  @override
  List<Object> get props => [businesses];

  @override
  String toString() => 'StartBeaconMonitoring { businesses: $businesses }';
}

class Enter extends BeaconEvent {
  final business_beacon.Beacon beacon;

  const Enter({required this.beacon});

  @override
  List<Object> get props => [beacon];

  @override
  String toString() => 'Enter { beacon: $beacon }';
}

class Exit extends BeaconEvent {
  final business_beacon.Beacon beacon;

  const Exit({required this.beacon});

  @override
  List<Object> get props => [beacon];

  @override
  String toString() => 'Exit { beacon: $beacon }';
}

class BeaconCancelled extends BeaconEvent {}
