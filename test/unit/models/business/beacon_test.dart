import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/beacon.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Beacon Tests", () {
    test("Beacon can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateBeacon();
      var beacon = Beacon.fromJson(json: json);
      expect(beacon, isA<Beacon>());
    });
  });
}