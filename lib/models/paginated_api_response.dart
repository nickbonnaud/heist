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
    @required String nextPageString
  }) :
    nextPage = nextPageString != 'null' 
      ? int.parse(nextPageString.substring(nextPageString.indexOf("page=") + 5))
      : null;
}