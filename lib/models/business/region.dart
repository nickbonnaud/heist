import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Region extends Equatable {
  final String identifier;
  final String city;
  final String state;
  final String zip;
  final String? neighborhood;

  const Region({
    required this.identifier, 
    required this.city,
    required this.state,
    required this.zip,
    required this.neighborhood
  });

  Region.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      city = json['city'],
      state = json['state'],
      zip = json['zip'],
      neighborhood = json['neighborhood'];
  
  @override 
  List<Object?> get props => [identifier, city, state, zip, neighborhood];

  @override
  String toString() => 'Region { identifier: $identifier, city: $city, state: $state, zip: $zip, neighborhood: $neighborhood }';
}