import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Hours extends Equatable {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  const Hours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday
  });

  Hours.fromJson({required Map<String, dynamic> json})
    : monday = json['monday'],
      tuesday = json['tuesday'],
      wednesday = json['wednesday'],
      thursday = json['thursday'],
      friday = json['friday'],
      saturday = json['saturday'],
      sunday = json['sunday'];
  
  @override
  List<Object> get props => [monday, tuesday, wednesday, thursday, friday, saturday, sunday];

  @override
  String toString() => 'Hours { monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday }';
}