import 'package:flutter_test/flutter_test.dart';
import 'package:heist/resources/helpers/distance_calculator.dart';

void main() {
  group("Distance Calculator Tests", () {

    test("Distance Calculator calculates correct distance", () {
      double lat1 = 35.910259;
      double lng1 = -79.055473;

      double lat2 = 35.994034;
      double lng2 = -78.898621;

      var distance = DistanceCalculator.getDistance(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2);
      expect((distance - 10.5).abs() < 2, true);
    });
  });
}