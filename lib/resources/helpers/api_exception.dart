import 'package:flutter/material.dart';

@immutable
class ApiException implements Exception {
  final String error;
  
  const ApiException({required this.error});

  @override
  String toString() => 'ApiException { error: $error }';
} 