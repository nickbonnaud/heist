import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/location_provider.dart';

void main() {
  group("Location Provider Tests", () {
    late LocationProvider locationProvider;

    setUp(() {
      locationProvider = const LocationProvider();
    });

    test("Sending Location returns PaginatedAPiResponse", () async {
      var response = await locationProvider.sendLocation(body: {});
      expect(response, isA<PaginatedApiResponse>());
    });
  });
}