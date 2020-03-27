import 'package:equatable/equatable.dart';

import 'beacon.dart';
import 'geo.dart';
import 'region.dart';

class Location extends Equatable {
  final Geo geo;
  final Beacon beacon;
  final Region region;

  Location({this.geo, this.beacon, this.region});

  static Location fromJson(Map<String, dynamic> json) {
    return Location(
      geo: Geo.fromJson(json['geo']),
      beacon: Beacon.fromJson(json['beacon']),
      region: Region.fromJson(json['region'])
    );
  }

  @override
  List<Object> get props => [geo, beacon, region];

  @override
  String toString() => 'Location { geo: $geo, beacon: $beacon, region: $region }';
}