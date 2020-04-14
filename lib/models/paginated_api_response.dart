import 'package:meta/meta.dart';

class PaginatedApiResponse {
  final dynamic body;
  final String error;
  final bool isOK;
  final int nextPage;

  PaginatedApiResponse({
    @required this.body,
    @required this.error,
    @required this.isOK,
    @required this.nextPage
  });
}