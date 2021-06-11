import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'location.dart';
import 'photos.dart';
import 'profile.dart';

@immutable
class Business extends Equatable {
  final String identifier;
  final Profile profile;
  final Photos photos;
  final Location location;

  Business({
    required this.identifier,
    required this.profile,
    required this.photos,
    required this.location,
  });

  Business.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      profile = Profile.fromJson(json: json['profile']),
      photos = Photos.fromJson(json: json['photos']),
      location = Location.fromJson(json: json['location']);

  @override
  List<Object> get props => [identifier, profile, photos, location];

  @override
  String toString() => 'Business { identifier: $identifier, profile: $profile, photos: $photos, location: $location }';
}