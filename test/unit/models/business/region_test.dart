import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/region.dart';
import 'package:heist/resources/http/mock_responses.dart';

void main() {
  group("Region Tests", () {

    test("Region can deserialize json", () {
      final Map<String, dynamic> json = MockResponses.generateRegion();
      var region = Region.fromJson(json: json);
      expect(region, isA<Region>());
    });
  });
}