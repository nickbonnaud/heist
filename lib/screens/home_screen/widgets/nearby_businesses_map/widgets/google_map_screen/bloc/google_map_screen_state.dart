part of 'google_map_screen_bloc.dart';

@immutable
class GoogleMapScreenState {
  final ScreenCoordinate? screenCoordinate;
  final Business? business;

  GoogleMapScreenState({required this.screenCoordinate, required this.business});

  factory GoogleMapScreenState.initial() {
    return GoogleMapScreenState(screenCoordinate: null, business: null);
  }

  @override
  String toString() => 'GoogleMapScreenState { screenCoordinate: $screenCoordinate, business: $business }';
}