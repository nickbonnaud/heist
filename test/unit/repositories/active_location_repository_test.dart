import 'package:flutter_test/flutter_test.dart';
import 'package:heist/models/api_response.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/providers/active_location_provider.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockActiveLocationProvider extends Mock implements ActiveLocationProvider {}

void main() {
  group("Active Location Repository Tests", () {
    late ActiveLocationRepository activeLocationRepository;
    late ActiveLocationProvider mockActiveLocationProvider;
    late ActiveLocationRepository activeLocationRepositoryWithMock;

    setUp(() {
      activeLocationRepository = ActiveLocationRepository(activeLocationProvider: ActiveLocationProvider());
      mockActiveLocationProvider = MockActiveLocationProvider();
      activeLocationRepositoryWithMock = ActiveLocationRepository(activeLocationProvider: mockActiveLocationProvider);
    });

    test("Active Location Repository can create ActiveLocation", () async {
      var activeLocation = await activeLocationRepository.enterBusiness(beaconIdentifier: "beaconIdentifier");
      expect(activeLocation, isA<ActiveLocation>());
    });

    test("Active Location Repository throws error on create ActiveLocation", () async {
      when(() => mockActiveLocationProvider.enterBusiness(body: any(named: "body")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        activeLocationRepositoryWithMock.enterBusiness(beaconIdentifier: "beaconIdentifier"),
        throwsA(isA<ApiException>())
      );
    });

    test("Active Location Repository can remove ActiveLocation", () async {
      var removed = await activeLocationRepository.exitBusiness(activeLocationId: "activeLocationId");
      expect(removed, isA<bool>());
    });

    test("Active Location Repository throws error on remove ActiveLocation", () async {
      when(() => mockActiveLocationProvider.exitBusiness(activeLocationId: any(named: "activeLocationId")))
        .thenAnswer((_) async => ApiResponse(body: {}, error: "error", isOK: false));

      expect(
        activeLocationRepositoryWithMock.exitBusiness(activeLocationId: "activeLocationId"), 
        throwsA(isA<ApiException>())
      );
    });
  });
}