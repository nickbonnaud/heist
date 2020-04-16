import 'package:equatable/equatable.dart';

import 'photos.dart';

class Profile extends Equatable {
  final String identifier;
  final String firstName;
  final String lastName;
  final Photos photos;
  final String error;

  Profile({this.identifier, this.firstName, this.lastName, this.photos, this.error});

  Profile.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      firstName = json['first_name'],
      lastName = json['last_name'],
      photos = json['photos'] != null ? Photos.fromJson(json['photos']) : null,
      error = "";
  
  Profile.withError(String error)
    : identifier = '',
      firstName = '',
      lastName = '',
      photos = null,
      error = error;

  Profile update({
    String identifier,
    String firstName,
    String lastName,
    Photos photos
  }) {
    return _copyWith(
      identifier: identifier,
      firstName: firstName,
      lastName: lastName,
      photos: photos
    );
  }
  
  Profile _copyWith({
    String identifier,
    String firstName,
    String lastName,
    Photos photos
  }) {
    return Profile(
      identifier: identifier ?? this.identifier,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photos: photos ?? this.photos,
      error: ""
    );
  }

  @override
  List<Object> get props => [identifier, firstName, lastName, photos, error];

  @override
  String toString() => 'Profile { identifier: $identifier, firstName: $firstName, lastName: $lastName, photos: $photos, error: $error }';
}