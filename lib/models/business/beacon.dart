import 'package:equatable/equatable.dart';

class Beacon extends Equatable {
  final String regionIdentifier;
  final String identifier;
  final int major;
  final int minor;

  Beacon({this.identifier, this.major, this.minor, this.regionIdentifier});

  static Beacon fromJson(Map<String, dynamic> json) {
    return Beacon(
      regionIdentifier: json['region_identifier'],
      identifier: json['identifier'],
      major: int.parse(json['major']),
      minor: int.parse(json['minor'])
    );
  }
  
  @override
  List<Object> get props => [identifier, major, minor, regionIdentifier];

  @override
  String toString() => 'Beacon { identifier: $identifier, major: $major, minor: $minor, regionIdentifier: $regionIdentifier }';
}