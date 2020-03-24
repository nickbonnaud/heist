import 'package:equatable/equatable.dart';

class Photos extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;

  Photos({this.name, this.smallUrl, this.largeUrl});

  Photos.fromJson(Map<String, dynamic> json) 
    : name = json['name'],
      smallUrl = json['small_url'],
      largeUrl = json['large_url'];

  @override
  List<Object> get props => [name, smallUrl, largeUrl];

  @override
  String toString() => 'Photos { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl }';
}