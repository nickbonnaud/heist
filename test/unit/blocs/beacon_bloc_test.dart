import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/repositories/beacon_repository.dart';

class MockBeaconRepository extends Mock implements BeaconRepository {}
class MockActiveLocationBloc extends Mock implements ActiveLocationBloc {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}
class MockBusiness extends Mock implements Business {}

void main() {
  group("Beacon Bloc Tests", () {
    late BeaconRepository beaconRepository;
    late ActiveLocationBloc activeLocationBloc;
    late BeaconBloc beaconBloc;

    setUp(() {
      registerFallbackValue(NewActiveLocation(beaconIdentifier: faker.guid.guid()));
      registerFallbackValue(RemoveActiveLocation(beaconIdentifier: faker.guid.guid()));
      beaconRepository = MockBeaconRepository();
      when(() => beaconRepository.startMonitoring(businesses: any(named: "businesses")))
        .thenAnswer((_) => Stream.fromIterable([]));

      activeLocationBloc = MockActiveLocationBloc();
      
      final NearbyBusinessesBloc nearbyBusinessesBloc = MockNearbyBusinessesBloc();
      whenListen(nearbyBusinessesBloc, Stream.fromIterable([NearbyUninitialized()]));
      beaconBloc = BeaconBloc(beaconRepository: beaconRepository, activeLocationBloc: activeLocationBloc, nearbyBusinessesBloc: nearbyBusinessesBloc);
    });

    tearDown(() {
      beaconBloc.close();
    });

    test("Initial state of BeaconBloc is BeaconUninitialized()", () {
      expect(beaconBloc.state, isA<BeaconUninitialized>());
    });

    blocTest<BeaconBloc, BeaconState>(
      "Beacon Bloc StartBeaconMonitoring event yields state: [LoadingBeacons()], [Monitoring()]",
      build: () => beaconBloc,
      act: (bloc) => bloc.add(StartBeaconMonitoring(businesses: [MockBusiness()])),
      expect: () => [isA<LoadingBeacons>(), isA<Monitoring>()]
    );

    blocTest<BeaconBloc, BeaconState>(
      "Beacon Bloc StartBeaconMonitoring event calls beaconRepository.startMonitoring",
      build: () => beaconBloc,
      act: (bloc) => bloc.add(StartBeaconMonitoring(businesses: [MockBusiness()])),
      verify: (_) {
        verify(() => beaconRepository.startMonitoring(businesses: any(named: "businesses"))).called(1);
      }
    );

    blocTest<BeaconBloc, BeaconState>(
      "Beacon Bloc BeaconCancelled event yields state: [BeaconsCancelled()]",
      build: () => beaconBloc,
      act: (bloc) => bloc.add(BeaconCancelled()),
      expect: () => [isA<BeaconsCancelled>()]
    );

    blocTest<BeaconBloc, BeaconState>(
      "Beacon Bloc Enter event calls activeLocation.add",
      build: () => beaconBloc,
      act: (bloc) {
        when(() => activeLocationBloc.add(any(that: isA<NewActiveLocation>()))).thenReturn(null);
        bloc.add(Enter(region: Region(identifier: faker.guid.guid(), proximityUUID: faker.guid.guid())));
      },
      verify: (_) {
        verify(() => activeLocationBloc.add(any(that: isA<NewActiveLocation>()))).called(1);
      }
    );

    blocTest<BeaconBloc, BeaconState>(
      "Beacon Bloc Exit event calls activeLocation.add",
      build: () => beaconBloc,
      act: (bloc) {
        when(() => activeLocationBloc.add(any(that: isA<RemoveActiveLocation>()))).thenReturn(null);
        bloc.add(Exit(region: Region(identifier: faker.guid.guid(), proximityUUID: faker.guid.guid())));
      },
      verify: (_) {
        verify(() => activeLocationBloc.add(any(that: isA<RemoveActiveLocation>()))).called(1);
      }
    );
  });
}