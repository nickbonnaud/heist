import 'package:equatable/equatable.dart';

class Geo extends Equatable {
  final String identifier;
  final double lat;
  final double lng;
  final int radius;

  Geo({this.identifier, this.lat, this.lng, this.radius});

  static Geo fromJson(Map<String, dynamic> json) {
    return Geo(
      identifier: json['identifier'],
      lat: double.parse(json['lat']),
      lng: double.parse(json['lng']),
      radius: int.parse(json['radius'])
    );
  }
  
  @override
  List<Object> get props => [identifier, lat, lng, radius];

  @override
  String toString() => 'Geo { identifier: $identifier, lat: $lat, lng: $lng, radius: $radius }';
}