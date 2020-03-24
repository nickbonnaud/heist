import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final Geo geo;
  final Beacon beacon;

  Location({this.geo, this.beacon});

  Location.fromJson(Map<String, dynamic> json)
    : geo = Geo.fromJson(json['geo']),
      beacon = Beacon.fromJson(json['beacon']);

  @override
  List<Object> get props => [geo, beacon];

  @override
  String toString() => 'Location { geo: $geo, beacon: $beacon }';
}

class Geo extends Equatable {
  final String identifier;
  final double lat;
  final double lng;
  final int radius;

  Geo({this.identifier, this.lat, this.lng, this.radius});

  Geo.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      lat = double.parse(json['lat']),
      lng = double.parse(json['lng']),
      radius = int.parse(json['radius']);

  @override
  List<Object> get props => [identifier, lat, lng, radius];

  @override
  String toString() => 'Geo { identifier: $identifier, lat: $lat, lng: $lng, radius: $radius }';
}

class Beacon extends Equatable {
  final String identifier;
  final String major;
  final String minor;

  Beacon({this.identifier, this.major, this.minor});

  Beacon.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      major = json['major'],
      minor = json['minor'];

  @override
  List<Object> get props => [identifier, major, minor];

  @override
  String toString() => 'Beacon { identifier: $identifier, major: $major, minor: $minor }';
}