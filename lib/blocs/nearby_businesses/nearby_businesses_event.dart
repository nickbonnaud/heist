part of 'nearby_businesses_bloc.dart';

abstract class NearbyBusinessesEvent extends Equatable {
  const NearbyBusinessesEvent();
}

class FetchNearby extends NearbyBusinessesEvent {
  final double lat;
  final double lng;

  const FetchNearby({@required this.lat, @required this.lng});

  @override
  List<Object> get props => [lat, lng];

  @override
  String toString() => 'FetchNearby { lat: $lat, lng: $lng }';
}
