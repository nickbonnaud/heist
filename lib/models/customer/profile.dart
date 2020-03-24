import 'package:equatable/equatable.dart';
import 'package:heist/models/customer/photos.dart';

class Profile extends Equatable {
  final String identifier;
  final String firstName;
  final String lastName;
  final Photos photos;

  Profile({this.identifier, this.firstName, this.lastName, this.photos});

  Profile.fromJson(Map<String, dynamic> json)
    : identifier = json['identifier'],
      firstName = json['first_name'],
      lastName = json['last_name'],
      photos = json['photos'] != null ? Photos.fromJson(json['photos']) : null;

  @override
  List<Object> get props => [identifier, firstName, lastName, photos];

  @override
  String toString() => 'Profile { identifier: $identifier, firstName: $firstName, lastName: $lastName, photos: $photos }';
}