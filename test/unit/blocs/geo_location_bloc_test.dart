import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:heist/blocs/geo_location/geo_location_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/repositories/geolocator_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockGeolocatorRepository extends Mock implements GeolocatorRepository {}
class MockPermissionsBloc extends Mock implements PermissionsBloc {}

void main() {
  group("Geo Location Bloc Tests", () {
    late GeolocatorRepository geolocatorRepository;
    late GeoLocationBloc geoLocationBloc;
    late PermissionsBloc permissionsBloc;

    setUp(() {
      geolocatorRepository = MockGeolocatorRepository();
      permissionsBloc = MockPermissionsBloc();
      whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([]));
      geoLocationBloc = GeoLocationBloc(geolocatorRepository: geolocatorRepository, permissionsBloc: permissionsBloc);
    });

    tearDown(() {
      geoLocationBloc.close();
    });

    test("Initial state of GeoLocationBloc is Uninitialized", () {
      expect(geoLocationBloc.state, isA<Uninitialized>());
    });

    test("Geo Location Bloc has isGeoLocationReady getter", () {
      expect(geoLocationBloc.isGeoLocationReady, isA<bool>());
    });

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc has currentLocation getter",
      build: () => geoLocationBloc,
      seed: () => const LocationLoaded(latitude: 1.0, longitude: 1.0),
      verify: (_) {
        expect(geoLocationBloc.currentLocation, {'lat': 1.0, 'lng': 1.0});
      }
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc GeoLocationReady event yields state: [Loading()], [LocationLoaded()]",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchMed())
          .thenAnswer((_) async => const Position(longitude: 3.0, latitude: 4.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        bloc.add(GeoLocationReady());
      },
      expect: () => [isA<Loading>(), isA<LocationLoaded>()],
      verify: (_) {
        expect((geoLocationBloc.state as LocationLoaded).latitude, 4.0);
        expect((geoLocationBloc.state as LocationLoaded).longitude, 3.0);
      }
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc GeoLocationReady event calls geolocatorRepository.fetchMed()",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchMed())
          .thenAnswer((_) async => const Position(longitude: 3.0, latitude: 4.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        bloc.add(GeoLocationReady());
      },
      verify: (_) {
        verify(() => geolocatorRepository.fetchMed()).called(1);
      }
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc GeoLocationReady on error yields state: [Loading()], [FetchFailure]",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchMed())
          .thenThrow(TimeoutException("message"));

        bloc.add(GeoLocationReady());
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()],
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc FetchLocation event yields state: [Loading()], [LocationLoaded()]",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchHigh())
          .thenAnswer((_) async => const Position(longitude: 10.0, latitude: 2.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        bloc.add(const FetchLocation(accuracy: Accuracy.high));
      },
      expect: () => [isA<Loading>(), isA<LocationLoaded>()],
      verify: (_) {
        expect((geoLocationBloc.state as LocationLoaded).latitude, 2.0);
        expect((geoLocationBloc.state as LocationLoaded).longitude, 10.0);
      }
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc FetchLocation calls geolocatorRepository.fetchHigh()",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchHigh())
          .thenAnswer((_) async => const Position(longitude: 10.0, latitude: 2.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        bloc.add(const FetchLocation(accuracy: Accuracy.high));
      },
      expect: () => [isA<Loading>(), isA<LocationLoaded>()],
      verify: (_) {
        verify(() => geolocatorRepository.fetchHigh()).called(1);
      }
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc FetchLocation on error yields state: [Loading()], [FetchFailure]",
      build: () => geoLocationBloc,
      act: (bloc) {
        when(() => geolocatorRepository.fetchHigh())
          .thenThrow(TimeoutException("message"));

        bloc.add(const FetchLocation(accuracy: Accuracy.high));
      },
      expect: () => [isA<Loading>(), isA<FetchFailure>()],
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc _permissionsBlocSubscription => [!this.isGeoLocationReady && state.onStartPermissionsValid] changes state [isA<Loading>(), isA<LocationLoaded>()]",
      build: () {
        when(() => geolocatorRepository.fetchMed())
          .thenAnswer((_) async => const Position(longitude: 3.0, latitude: 4.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([const PermissionsState(bleEnabled: true, locationEnabled: true, notificationEnabled: true, beaconEnabled: true, checksComplete: true)]));
        return GeoLocationBloc(geolocatorRepository: geolocatorRepository, permissionsBloc: permissionsBloc);
      },
      expect: () => [isA<Loading>(), isA<LocationLoaded>()],
    );

    blocTest<GeoLocationBloc, GeoLocationState>(
      "Geo Location Bloc _permissionsBlocSubscription => [!this.isGeoLocationReady && !state.onStartPermissionsValid] does not change state",
      build: () {
        when(() => geolocatorRepository.fetchMed())
          .thenAnswer((_) async => const Position(longitude: 3.0, latitude: 4.0, timestamp: null, accuracy: 1.0, altitude: 1.0, heading: 1.0, speed: 1.0, speedAccuracy: 1.0));

        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([const PermissionsState(bleEnabled: false, locationEnabled: true, notificationEnabled: true, beaconEnabled: true, checksComplete: true)]));
        return GeoLocationBloc(geolocatorRepository: geolocatorRepository, permissionsBloc: permissionsBloc);
      },
      expect: () => [],
    );
  });
}