import 'package:equatable/equatable.dart';

class Photos extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;
  final String error;

  Photos({this.name, this.smallUrl, this.largeUrl, this.error});

  static Photos fromJson(Map<String, dynamic> json) {
    return Photos(
      name: json['name'],
      smallUrl: json['small_url'],
      largeUrl: json['large_url'],
      error: ""
    );
  }

  static Photos withError(String error) {
    return Photos(
      name: null,
      smallUrl: null,
      largeUrl: null,
      error: error
    );
  }
  
  @override
  List<Object> get props => [name, smallUrl, largeUrl, error];

  @override
  String toString() => 'Photos { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl, error: $error }';
}