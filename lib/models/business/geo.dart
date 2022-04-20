import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Geo extends Equatable {
  final String identifier;
  final double lat;
  final double lng;
  final int radius;

  const Geo({
    required this.identifier,
    required this.lat,
    required this.lng,
    required this.radius
  });

  Geo.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      lat = json['lat'],
      lng = json['lng'],
      radius = json['radius'];
  
  @override
  List<Object> get props => [identifier, lat, lng, radius];

  @override
  String toString() => 'Geo { identifier: $identifier, lat: $lat, lng: $lng, radius: $radius }';
}