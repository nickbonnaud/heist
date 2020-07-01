import 'package:meta/meta.dart';

class Status {
  final String name;
  final int code;

  Status({@required this.name, @required this.code});
  
  Status.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      code = int.parse(json['code']);

  @override
  String toString() => 'Status { name: $name, code: $code }';
}