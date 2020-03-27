import 'package:equatable/equatable.dart';

class Photo extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;

  Photo({this.name, this.smallUrl, this.largeUrl});

  static Photo fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'],
      smallUrl: json['small_url'],
      largeUrl: json['large_url']
    );
  }

  @override
  List<Object> get props => [name, smallUrl, largeUrl];

  @override
  String toString() => 'Photo { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl }';
}