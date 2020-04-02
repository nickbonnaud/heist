import 'package:equatable/equatable.dart';

import 'hours.dart';

class Profile extends Equatable {
  final String name;
  final String website;
  final String phone;
  final String description;
  final Hours hours;
  final String error;
  
  Profile({this.name, this.website, this.phone, this.description, this.hours, this.error});

  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      website: json['website'],
      phone: json['phone'],
      description: json['description'],
      hours: Hours.fromJson(json['hours']),
      error: ''
    );
  }

  static Profile withError(String error) {
    return Profile(
      name: "",
      website: "",
      phone: "",
      description: "",
      hours: null,
      error: error
    );
  }
  
  @override
  List<Object> get props => [name, website, description, hours, error];

  @override
  String toString() => 'Profile { name: $name, website: $website, phone: $phone, description: $description, hours: $hours, error: $error }';
}