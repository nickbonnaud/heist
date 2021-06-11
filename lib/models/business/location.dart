import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'beacon.dart';
import 'geo.dart';
import 'region.dart';

@immutable
class Location extends Equatable {
  final Geo geo;
  final Beacon beacon;
  final Region region;

  Location({
    required this.geo,
    required this.beacon,
    required this.region
  });

  Location.fromJson({required Map<String, dynamic> json})
    : geo = Geo.fromJson(json: json['geo']),
      beacon = Beacon.fromJson(json: json['beacon']),
      region = Region.fromJson(json: json['region']);

  @override
  List<Object> get props => [geo, beacon, region];

  @override
  String toString() => 'Location { geo: $geo, beacon: $beacon, region: $region }';
}