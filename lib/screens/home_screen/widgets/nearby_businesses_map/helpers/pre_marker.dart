import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:heist/models/business/business.dart';

class PreMarker extends Equatable {
  final String markerId;
  final double lat;
  final double lng;
  final BitmapDescriptor icon;
  final Business business;

  PreMarker({this.markerId, this.lat, this.lng, this.icon, this.business});

  @override
  List<Object> get props => [markerId, lat, lng, icon, business];

  @override
  String toString() => 'PreMarker: { markerId: $markerId, lat: $lat, lng: $lng, icon: $icon, business: $business }';
}