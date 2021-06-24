import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/icon_creator_repository.dart';
import 'package:heist/repositories/location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:heist/screens/home_screen/widgets/nearby_businesses_map/models/pre_marker.dart';

class MockLocationRepository extends Mock implements LocationRepository {}
class MockIconCreatorRepository extends Mock implements IconCreatorRepository {}
class MockGeoLocationBloc extends Mock implements GeoLocationBloc {}
class MockBusiness extends Mock implements Business {}
class MockPreMarker extends Mock implements PreMarker {}

void main() {
  group("Nearby Businesses Bloc Tests", () {
    late LocationRepository locationRepository;
    late IconCreatorRepository iconCreatorRepository;
    late NearbyBusinessesBloc nearbyBusinessesBloc;
    late GeoLocationBloc geoLocationBloc;

    setUp(() {
      locationRepository = MockLocationRepository();
      iconCreatorRepository = MockIconCreatorRepository();

      geoLocationBloc = MockGeoLocationBloc();
      whenListen(geoLocationBloc, Stream<GeoLocationState>.fromIterable([]));

      nearbyBusinessesBloc = NearbyBusinessesBloc(locationRepository: locationRepository, iconCreatorRepository: iconCreatorRepository, geoLocationBloc: geoLocationBloc);
    });

    tearDown(() {
      nearbyBusinessesBloc.close();
    });

    test("Initial state of NearbyBusinessesBloc is NearbyUninitialized()", () {
      expect(nearbyBusinessesBloc.state, isA<NearbyUninitialized>());
    });

    blocTest<NearbyBusinessesBloc, NearbyBusinessesState>(
      "Nearby Businesses Bloc FetchNearby event yields state: [NearbyBusinessLoaded]",
      build: () => nearbyBusinessesBloc,
      act: (bloc) {
        when(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation")))
          .thenAnswer((_) async => [MockBusiness(), MockBusiness(), MockBusiness()]);
        
        when(() => iconCreatorRepository.createPreMarkers(businesses: any(named: 'businesses')))
          .thenAnswer((_) async => [MockPreMarker(), MockPreMarker(), MockPreMarker()]);

        bloc.add(FetchNearby(lat: 1.0, lng: 1.0));
      },
      expect: () => [isA<NearbyBusinessLoaded>()],
      verify: (_) {
        expect((nearbyBusinessesBloc.state as NearbyBusinessLoaded).businesses, isA<List<Business>>());
        expect((nearbyBusinessesBloc.state as NearbyBusinessLoaded).preMarkers, isA<List<PreMarker>>());
      }
    );

    blocTest<NearbyBusinessesBloc, NearbyBusinessesState>(
      "Nearby Businesses Bloc FetchNearby calls locationRepository.sendLocation and iconCreatorRepository.createPreMarkers",
      build: () => nearbyBusinessesBloc,
      act: (bloc) {
        when(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation")))
          .thenAnswer((_) async => [MockBusiness(), MockBusiness(), MockBusiness()]);
        
        when(() => iconCreatorRepository.createPreMarkers(businesses: any(named: 'businesses')))
          .thenAnswer((_) async => [MockPreMarker(), MockPreMarker(), MockPreMarker()]);

        bloc.add(FetchNearby(lat: 1.0, lng: 1.0));
      },
      verify: (_) {
        verify(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation"))).called(1);
        verify(() => iconCreatorRepository.createPreMarkers(businesses: any(named: "businesses"))).called(1);
      }
    );

    blocTest<NearbyBusinessesBloc, NearbyBusinessesState>(
      "Nearby Businesses Bloc FetchNearby event on error yields state: [FailedToLoadNearby]",
      build: () => nearbyBusinessesBloc,
      act: (bloc) {
        when(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation")))
          .thenThrow(ApiException(error: "Error!"));

        bloc.add(FetchNearby(lat: 1.0, lng: 1.0));
      },
      expect: () => [isA<FailedToLoadNearby>()],
      verify: (_) {
        expect((nearbyBusinessesBloc.state as FailedToLoadNearby).error, "Error!");
      }
    );

    blocTest<NearbyBusinessesBloc, NearbyBusinessesState>(
      "Nearby Businesses Bloc geoLocationBlocSubscription => [state is LocationLoaded] changes state [sA<NearbyBusinessLoaded>()]",
      build: () {
        when(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation")))
          .thenAnswer((_) async => [MockBusiness(), MockBusiness(), MockBusiness()]);
        
        when(() => iconCreatorRepository.createPreMarkers(businesses: any(named: 'businesses')))
          .thenAnswer((_) async => [MockPreMarker(), MockPreMarker(), MockPreMarker()]);

        whenListen(geoLocationBloc, Stream<GeoLocationState>.fromIterable([LocationLoaded(latitude: 1.0, longitude: 1.0)]));

        return NearbyBusinessesBloc(locationRepository: locationRepository, iconCreatorRepository: iconCreatorRepository, geoLocationBloc: geoLocationBloc);
      },
      expect: () => [isA<NearbyBusinessLoaded>()],
    );

    blocTest<NearbyBusinessesBloc, NearbyBusinessesState>(
      "Nearby Businesses Bloc geoLocationBlocSubscription => [state is !LocationLoaded] does not change state",
      build: () {
        when(() => locationRepository.sendLocation(lat: any(named: "lat"), lng: any(named: "lng"), startLocation: any(named: "startLocation")))
          .thenAnswer((_) async => [MockBusiness(), MockBusiness(), MockBusiness()]);
        
        when(() => iconCreatorRepository.createPreMarkers(businesses: any(named: 'businesses')))
          .thenAnswer((_) async => [MockPreMarker(), MockPreMarker(), MockPreMarker()]);

        whenListen(geoLocationBloc, Stream<GeoLocationState>.fromIterable([Uninitialized()]));

        return NearbyBusinessesBloc(locationRepository: locationRepository, iconCreatorRepository: iconCreatorRepository, geoLocationBloc: geoLocationBloc);
      },
      expect: () => [],
    );
  });
}