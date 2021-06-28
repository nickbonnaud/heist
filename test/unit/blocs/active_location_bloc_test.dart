import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

class MockActiveLocationRepository extends Mock implements ActiveLocationRepository {}
class MockActiveLocation extends Mock implements ActiveLocation {}

void main() {
  group("Active Location Bloc Tests", () {
    late ActiveLocationRepository activeLocationRepository;
    late ActiveLocationBloc activeLocationBloc;

    late ActiveLocationState _baseState;
    late ActiveLocation _activeLocation;

    setUp(() {
      activeLocationRepository = MockActiveLocationRepository();
      activeLocationBloc = ActiveLocationBloc(activeLocationRepository: activeLocationRepository);
      
      _baseState = ActiveLocationState.initial();
    });

    tearDown(() {
      activeLocationBloc.close();
    });

    test("Initial state of ActiveLocationBloc is ActiveLocationState.initial()", () async {
      expect(activeLocationBloc.state, ActiveLocationState.initial());
    });

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation changes state: [addingLocations: activeLocation], [activeLocations: activeLocation, addingLocations: empty]",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier")))
          .thenAnswer((_) async => _activeLocation);

        bloc.add(NewActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(addingLocations: [_activeLocation.beaconIdentifier]);
        ActiveLocationState secondState = firstState.update(addingLocations: [], activeLocations: [_activeLocation]);
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation calls activeLocationRepository.enterBusiness",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier")))
          .thenAnswer((_) async => _activeLocation);

        bloc.add(NewActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      verify: (_){
        verify(() => activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier"))).called(1);
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation does not change state or call activeLocationRepository.enterBusiness if activeLocations list contains activeLocation",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());

        return _baseState.update(activeLocations: [_activeLocation]);
      },
      act: (bloc) {
        bloc.add(NewActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() =>  activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation does not change state or call activeLocationRepository.enterBusiness if addingActiveLocations list contains activeLocation",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());

        return _baseState.update(addingLocations: [_activeLocation.beaconIdentifier]);
      },
      act: (bloc) {
        bloc.add(NewActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() =>  activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation on error changes state: [addingLocations: activeLocation], [addingLocations: empty, errorMessage: error]",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => activeLocationRepository.enterBusiness(beaconIdentifier: any(named: "beaconIdentifier")))
          .thenThrow(ApiException(error: "error"));

        bloc.add(NewActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(addingLocations: [_activeLocation.beaconIdentifier]);
        ActiveLocationState secondState = firstState.update(addingLocations: [], errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation changes state: [removingLocation: activeLocation], [activeLocations: [], removingLocation: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => true);

        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.beaconIdentifier]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], activeLocations: []);
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation calls activeLocationRepository.exitBusiness",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => true);

        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      verify: (_) {
        verify(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId"))).called(1);
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation does not change state or call activeLocationRepository.exitBusiness if activeLocations list does not contain activeLocation",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation does not change state or call activeLocationRepository.exitBusiness if removingLocations contain activeLocation",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(removingLocations: [_activeLocation.beaconIdentifier]);
        return _baseState;
      },
      act: (bloc) {
        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation on exitBusiness return false changes state: [removingLocation: activeLocation], [errorMessage: error, removingLocation: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => false);

        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.beaconIdentifier]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], errorMessage: "Unable to remove active location.");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation on error changes state: [removingLocation: activeLocation], [errorMessage: error, removingLocation: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        when(() => _activeLocation.beaconIdentifier).thenReturn(faker.guid.guid());
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenThrow(ApiException(error: "error occurred"));

        bloc.add(RemoveActiveLocation(beaconIdentifier: _activeLocation.beaconIdentifier));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.beaconIdentifier]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], errorMessage: "error occurred");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event Reset state: [errorMessage: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _baseState = _baseState.update(errorMessage: "some error");
        return _baseState;
      },
      act: (bloc) {
        bloc.add(ResetActiveLocations());
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(errorMessage: "");
        return [firstState];
      }
    );
  });
}