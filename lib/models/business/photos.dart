import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'photo.dart';

@immutable
class Photos extends Equatable {
  final Photo logo;
  final Photo banner;

  Photos({required this.logo, required this.banner});

  Photos.fromJson({required Map<String, dynamic> json})
    : logo = Photo.fromJson(json: json['logo']),
      banner = Photo.fromJson(json: json['banner']);

  @override
  List<Object> get props => [logo, banner];

  @override
  String toString() => 'Photos { logo: $logo, banner: $banner }';
}