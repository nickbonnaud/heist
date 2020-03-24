part of 'geo_location_bloc.dart';

abstract class GeoLocationEvent extends Equatable {
  const GeoLocationEvent();

  @override
  List<Object> get props => [];
}

class GeoLocationReady extends GeoLocationEvent {}

class FetchLocation extends GeoLocationEvent {
  final Accuracy accuracy;

  FetchLocation({@required this.accuracy});

  @override
  List<Object> get props => [accuracy];

  @override
  String toString() => 'FetchLocation { accuracy: $accuracy }';
}
