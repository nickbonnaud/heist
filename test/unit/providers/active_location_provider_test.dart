import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/providers/active_location_provider.dart';

void main() {
  group("Active Location Provider Tests", () {
    late ActiveLocationProvider activeLocationProvider;

    setUp(() {
      activeLocationProvider = ActiveLocationProvider();
    });

    test("Entering business data returns ApiResponse", () async {
      var response = await activeLocationProvider.enterBusiness(body: {});
      expect(response, isA<ApiResponse>());
    });

    test("Exiting business data returns ApiResponse", () async {
      var response = await activeLocationProvider.exitBusiness(activeLocationId: "activeLocationId");
      expect(response, isA<ApiResponse>());
    });
  });
}