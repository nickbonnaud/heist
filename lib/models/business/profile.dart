import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'hours.dart';

@immutable
class Profile extends Equatable {
  final String name;
  final String website;
  final String phone;
  final String description;
  final Hours hours;
  
  const Profile({
    required this.name,
    required this.website,
    required this.phone,
    required this.description,
    required this.hours,
  });

  Profile.fromJson({required Map<String, dynamic> json})
    : name = json['name'],
      website = json['website'],
      phone = json['phone'],
      description = json['description'],
      hours = Hours.fromJson(json: json['hours']);
  
  @override
  List<Object> get props => [name, website, description, hours];

  @override
  String toString() => 'Profile { name: $name, website: $website, phone: $phone, description: $description, hours: $hours }';
}