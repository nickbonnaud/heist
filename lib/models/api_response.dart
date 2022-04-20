import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class ApiResponse extends Equatable {
  final Map<String, dynamic> body;
  final String error;
  final bool isOK;

  const ApiResponse({
    required this.body,
    required this.error,
    required this.isOK,
  });


  @override
  List<Object> get props => [body, error, isOK];

  @override
  String toString() => 'ApiResponse { body: $body, error: $error, isOK: $isOK }';
}