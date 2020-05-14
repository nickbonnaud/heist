import 'package:meta/meta.dart';

class ApiResponse {
  final dynamic body;
  final String error;
  final bool isOK;

  ApiResponse({
    @required this.body,
    @required this.error,
    @required this.isOK,
  });

  @override
  String toString() => 'ApiResponse { body: $body, error: $error, isOK: $isOK }';
}