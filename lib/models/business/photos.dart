import 'package:equatable/equatable.dart';

class Photos extends Equatable {
  final Photo logo;
  final Photo banner;

  Photos({this.logo, this.banner});

  Photos.fromJson(Map<String, dynamic> json)
    : logo = Photo.fromJson(json['logo']),
      banner = Photo.fromJson(json['banner']);

  @override
  List<Object> get props => [logo, banner];

  @override
  String toString() => 'Photos { logo: $logo, banner: $banner }';
}

class Photo extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;

  Photo({this.name, this.smallUrl, this.largeUrl});

  Photo.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      smallUrl = json['small_url'],
      largeUrl = json['large_url'];

  @override
  List<Object> get props => [name, smallUrl, largeUrl];

  @override
  String toString() => 'Photo { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl }';
}