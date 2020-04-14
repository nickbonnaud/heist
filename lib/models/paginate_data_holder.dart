import 'package:meta/meta.dart';

class PaginateDataHolder {
  final dynamic data;
  final int nextPage;

  PaginateDataHolder({@required this.data, @required this.nextPage});
}