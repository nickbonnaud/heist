import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/status.dart';

void main() {
  group("Status Tests", () {

    test("Status can deserialize json", () {
      final Map<String, dynamic> json = {'name': 'status', 'code': 100};
      var status = Status.fromJson(json: json);
      expect(status, isA<Status>());
    });
  });
}