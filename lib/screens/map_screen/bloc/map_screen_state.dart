part of 'map_screen_bloc.dart';

abstract class MapScreenState extends Equatable {
  const MapScreenState();

  @override
  List<Object> get props => [];
}

class MapScreenEmpty extends MapScreenState {}

class MarkersLoading extends MapScreenState {}

class MarkersLoaded extends MapScreenState {
  final List<Business> businesses;
  final List<PreMarker> preMarkers;

  const MarkersLoaded({@required this.businesses, @required this.preMarkers})
    : assert(businesses != null);

  @override
  List<Object> get props => [businesses, preMarkers];

  @override
  String toString() => 'MarkersLoaded: { businesses: $businesses, preMarkers: $preMarkers }';
}

class NoMarkers extends MapScreenState {}

class FetchMarkersError extends MapScreenState {}