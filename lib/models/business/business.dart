import 'package:equatable/equatable.dart';

import 'location.dart';
import 'photos.dart';
import 'profile.dart';

class Business extends Equatable {
  final String identifier;
  final Profile profile;
  final Photos photos;
  final Location location;
  final String error;

  Business({this.identifier, this.profile, this.photos, this.location, this.error});

  Business.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      profile = Profile.fromJson(json['profile']),
      photos = Photos.fromJson(json['photos']),
      location = Location.fromJson(json['location']),
      error = '';

  Business.withError(String error)
    : identifier = null,
      profile = null,
      photos = null,
      location = null,
      error = error;

  @override
  List<Object> get props => [identifier, profile, photos, location, error];

  @override
  String toString() => 'Business { identifier: $identifier, profile: $profile, photos: $photos, location: $location, error: $error }';
}