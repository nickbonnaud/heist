import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Photos extends Equatable {
  final String name;
  final String smallUrl;
  final String largeUrl;

  const Photos({
    required this.name,
    required this.smallUrl,
    required this.largeUrl, 
  });

  Photos.fromJson({required Map<String, dynamic> json})
    : name = json['name'],
      smallUrl = json['small_url'],
      largeUrl = json['large_url'];
  
  const Photos.empty()
    : name = "",
      smallUrl = "",
      largeUrl = "";
  
  @override
  List<Object> get props => [name, smallUrl, largeUrl];

  @override
  String toString() => 'Photos { name: $name, smallUrl: $smallUrl, largeUrl: $largeUrl }';
}