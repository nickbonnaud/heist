import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final String identifier;
  final String city;
  final String state;
  final String zip;
  final String neighborhood;

  Region({this.identifier, this.city, this.state, this.zip, this.neighborhood});

  static Region fromJson(Map<String, dynamic> json) {
    return Region(
      identifier: json['identifier'],
      city: json['city'],
      state: json['state'],
      zip: json['zip'],
      neighborhood: json['neighborhood']
    );
  }
  
  @override 
  List<Object> get props => [identifier, city, state, zip, neighborhood];

  @override
  String toString() => 'Region { identifier: $identifier, city: $city, state: $state, zip: $zip, neighborhood: $neighborhood }';
}