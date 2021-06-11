
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

@immutable
class Token extends Equatable {
  final String value;

  Token({required this.value});

  bool get expired => JwtDecoder.isExpired(this.value);
  
  bool get valid {
    try {
      JwtDecoder.decode(this.value);
      return !this.expired;
    } on FormatException catch (_) {
      return false;
    }
  }

  Token.fromJson({required Map<String, dynamic> json})
    : value = json['token'];

  @override
  List<Object> get props => [value];

  @override
  String toString() => 'Token { value: $value }';
}