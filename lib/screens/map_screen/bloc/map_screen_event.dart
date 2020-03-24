part of 'map_screen_bloc.dart';

abstract class MapScreenEvent extends Equatable {
  const MapScreenEvent();
}

class SendOnStartLocation extends MapScreenEvent {
  final double lat;
  final double lng;

  const SendOnStartLocation({@required this.lat, @required this.lng})
    : assert(lat != null && lng != null);

  @override
  List<Object> get props => [lat, lng];
}

class SendLocation extends MapScreenEvent {
  final double lat;
  final double lng;

  const SendLocation({@required this.lat, @required this.lng})
    : assert(lat != null && lng != null);

  @override
  List<Object> get props => [lat, lng];
}
