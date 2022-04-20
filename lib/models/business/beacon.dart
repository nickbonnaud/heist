import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Beacon extends Equatable {
  final String regionIdentifier;
  final String proximityUUID;
  final int major;
  final int minor;

  const Beacon({
    required this.regionIdentifier,
    required this.proximityUUID,
    required this.major,
    required this.minor,
  });

  Beacon.fromJson({required Map<String, dynamic> json}) 
    : regionIdentifier = json['region_identifier'],
      proximityUUID = json['proximity_uuid'],
      major = json['major'],
      minor = json['minor'];
  
  @override
  List<Object> get props => [regionIdentifier, proximityUUID, major, minor];

  @override
  String toString() => 'Beacon { regionIdentifier: $regionIdentifier, proximityUUID: $proximityUUID, major: $major, minor: $minor }';
}