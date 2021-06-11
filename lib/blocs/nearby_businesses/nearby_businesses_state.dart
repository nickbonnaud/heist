part of 'nearby_businesses_bloc.dart';

abstract class NearbyBusinessesState extends Equatable {
  const NearbyBusinessesState();

  @override
  List<Object> get props => [];

  List<Business> get businesses => [];
}

class NearbyUninitialized extends NearbyBusinessesState {}

class NearbyBusinessLoaded extends NearbyBusinessesState {
  final List<Business> businesses;
  final List<PreMarker> preMarkers;

  const NearbyBusinessLoaded({required this.businesses, required this.preMarkers});

  @override
  List<Object> get props => [businesses, preMarkers];

  @override
  String toString() => 'NearbyBusinessLoaded {businesses: $businesses, preMarkers: $preMarkers }';
}

class FailedToLoadNearby extends NearbyBusinessesState {
  final String error;

  const FailedToLoadNearby({required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'FailedToLoadNearby { error: $error }';
}