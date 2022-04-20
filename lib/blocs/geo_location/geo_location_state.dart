part of 'geo_location_bloc.dart';

abstract class GeoLocationState extends Equatable {
  const GeoLocationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends GeoLocationState {}

class Loading extends GeoLocationState {}

class PermissionNotGranted extends GeoLocationState {}

class LocationLoaded extends GeoLocationState {
  final double latitude;
  final double longitude;

  const LocationLoaded({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() => 'LocationLoaded { latitude: $latitude, longitude: $longitude }';
}

class FetchFailure extends GeoLocationState {}