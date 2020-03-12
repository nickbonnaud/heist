part of 'geolocation_bloc.dart';

abstract class GeolocationEvent extends Equatable {
  const GeolocationEvent();

  @override
  List<Object> get props => [];
}

class AppReady extends GeolocationEvent {}

class CheckPermission extends GeolocationEvent {}

class FetchLocation extends GeolocationEvent {}
