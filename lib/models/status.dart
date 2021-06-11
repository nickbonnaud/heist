import 'package:flutter/material.dart';

@immutable
class Status {
  final String name;
  final int code;

  Status({required this.name, required this.code});
  
  Status.fromJson({required Map<String, dynamic> json})
    : name = json['name'],
      code = json['code'];

  @override
  String toString() => 'Status { name: $name, code: $code }';
}