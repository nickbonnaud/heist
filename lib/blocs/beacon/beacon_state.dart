part of 'beacon_bloc.dart';

abstract class BeaconState extends Equatable {
  const BeaconState();

  @override
  List<Object> get props => [];
}

class BeaconUninitialized extends BeaconState {}

class LoadingBeacons extends BeaconState {}

class Monitoring extends BeaconState {}

class BeaconsCancelled extends BeaconState {}
