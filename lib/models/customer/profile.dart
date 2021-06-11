import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'photos.dart';

@immutable
class Profile extends Equatable {
  final String identifier;
  final String firstName;
  final String lastName;
  final Photos photos;

  Profile({
    required this.identifier,
    required this.firstName,
    required this.lastName,
    required this.photos,
  });

  Profile.fromJson({required Map<String, dynamic> json})
    : identifier = json['identifier'],
      firstName = json['first_name'],
      lastName = json['last_name'],
      photos = json['photos'] != null 
        ? Photos.fromJson(json: json['photos']) 
        : Photos.empty();
  
  Profile.empty()
    : identifier = '',
      firstName = '',
      lastName = '',
      photos = Photos.empty();

  Profile update({
    String? firstName,
    String? lastName,
    Photos? photos
  }) => Profile(
    identifier: this.identifier,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName, 
    photos: photos ?? this.photos
  );

  @override
  List<Object> get props => [identifier, firstName, lastName, photos];

  @override
  String toString() => 'Profile { identifier: $identifier, firstName: $firstName, lastName: $lastName, photos: $photos }';
}