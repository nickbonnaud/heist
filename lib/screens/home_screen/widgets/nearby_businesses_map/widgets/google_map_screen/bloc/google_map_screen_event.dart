part of 'google_map_screen_bloc.dart';

abstract class GoogleMapScreenEvent extends Equatable {
  const GoogleMapScreenEvent();

  @override
  List<Object> get props => [];
}

class Tapped extends GoogleMapScreenEvent {
  final ScreenCoordinate screenCoordinate;
  final Business business;

  const Tapped({@required this.screenCoordinate, @required this.business});

  @override
  List<Object> get props => [screenCoordinate, business];

  String toString() => 'Tapped { screenCoordinate: $screenCoordinate, business: $business }';
}

class Reset extends GoogleMapScreenEvent {}
