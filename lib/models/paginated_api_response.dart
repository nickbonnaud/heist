import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class PaginatedApiResponse extends Equatable {
  final List<Map<String, dynamic>> body;
  final String error;
  final bool isOK;
  final String? next;

  PaginatedApiResponse({
    required this.body,
    this.error = "",
    required this.isOK,
    this.next
  });

  @override
  List<Object?> get props => [body, error, isOK, next];

  @override
  String toString() => '''PaginatedApiResponse {
    body: $body,
    error: $error,
    isOk: $isOK,
    next: $next
  }''';
}