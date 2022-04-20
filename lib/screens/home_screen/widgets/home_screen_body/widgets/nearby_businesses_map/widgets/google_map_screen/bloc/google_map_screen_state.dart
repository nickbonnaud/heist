part of 'google_map_screen_bloc.dart';

@immutable
class GoogleMapScreenState extends Equatable {
  final ScreenCoordinate? screenCoordinate;
  final Business? business;

  const GoogleMapScreenState({required this.screenCoordinate, required this.business});

  factory GoogleMapScreenState.initial() {
    return const GoogleMapScreenState(screenCoordinate: null, business: null);
  }

  @override
  List<Object?> get props => [screenCoordinate, business];
  
  @override
  String toString() => 'GoogleMapScreenState { screenCoordinate: $screenCoordinate, business: $business }';
}