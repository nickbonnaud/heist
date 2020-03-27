import 'package:equatable/equatable.dart';

import 'photo.dart';

class Photos extends Equatable {
  final Photo logo;
  final Photo banner;

  Photos({this.logo, this.banner});

  static Photos fromJson(Map<String, dynamic> json) {
    return Photos(
      logo: Photo.fromJson(json['logo']),
      banner: Photo.fromJson(json['banner'])
    );
  }

  @override
  List<Object> get props => [logo, banner];

  @override
  String toString() => 'Photos { logo: $logo, banner: $banner }';
}