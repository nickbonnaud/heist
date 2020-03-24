import 'package:equatable/equatable.dart';

class Hours extends Equatable {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  Hours({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday
  });

  Hours.fromJson(Map<String, dynamic> json)
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