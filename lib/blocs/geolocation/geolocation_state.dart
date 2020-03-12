part of 'geolocation_bloc.dart';

abstract class GeolocationState extends Equatable {
  const GeolocationState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends GeolocationState {}

class PermissionGranted extends GeolocationState {}

class PermissionDenied extends GeolocationState {}

class PermissionUnknown extends GeolocationState {}

class Loading extends GeolocationState {}

class LocationLoaded extends GeolocationState {
  final double latitude;
  final double longitude;

  LocationLoaded({@required this.latitude, @required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];

  @override
  String toString() => 'LocationLoaded { latitude: $latitude, longitude: $longitude }';
}

class FetchFailure extends GeolocationState {}