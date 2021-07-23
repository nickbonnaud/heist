import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginated_api_response.dart';
import 'package:heist/providers/location_provider.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockLocationProvider extends Mock implements LocationProvider {}

void main() {
  group("Location Repository Tests", () {
    late LocationRepository locationRepository;
    late LocationProvider mockLocationProvider;
    late LocationRepository locationRepositoryWithMock;

    setUp(() {
      locationRepository = LocationRepository(locationProvider: LocationProvider());
      mockLocationProvider = MockLocationProvider();
      locationRepositoryWithMock = LocationRepository(locationProvider: mockLocationProvider);
    });

    test("Location Repository can send location", () async {
      var businesses = await locationRepository.sendLocation(lat: 1.0, lng: 1.0, startLocation: true);
      expect(businesses, isA<List<Business>>());
      expect(businesses.isNotEmpty, true);
    });

    test("Location Repository throws error on send location fail", () async {
      when(() => mockLocationProvider.sendLocation(body: any(named: 'body')))
        .thenAnswer((_) async => PaginatedApiResponse(body: [], isOK: false));
      
      expect(
        locationRepositoryWithMock.sendLocation(lat: 1.0, lng: 1.0, startLocation: true),
        throwsA(isA<ApiException>())
      );
    });
  });
}