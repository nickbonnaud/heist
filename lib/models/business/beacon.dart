import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Beacon extends Equatable {
  final String regionIdentifier;
  final String identifier;
  final int major;
  final int minor;

  Beacon({
    required this.identifier,
    required this.major,
    required this.minor,
    required this.regionIdentifier
  });

  Beacon.fromJson({required Map<String, dynamic> json}) 
    : regionIdentifier = json['region_identifier'],
      identifier = json['identifier'],
      major = json['major'],
      minor = json['minor'];
  
  @override
  List<Object> get props => [identifier, major, minor, regionIdentifier];

  @override
  String toString() => 'Beacon { identifier: $identifier, major: $major, minor: $minor, regionIdentifier: $regionIdentifier }';
}