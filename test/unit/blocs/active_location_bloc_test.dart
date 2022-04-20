import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/models/business/beacon.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/repositories/active_location_repository.dart';
import 'package:heist/resources/helpers/api_exception.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/mock_data_generator.dart';

class MockActiveLocationRepository extends Mock implements ActiveLocationRepository {}
class MockActiveLocation extends Mock implements ActiveLocation {}
class MockBeacon extends Mock implements Beacon {}

void main() {
  group("Active Location Bloc Tests", () {
    late ActiveLocationRepository activeLocationRepository;
    late ActiveLocationBloc activeLocationBloc;

    late ActiveLocationState _baseState;
    late ActiveLocation _activeLocation;

    late Business _business;

    setUp(() {
      registerFallbackValue(MockBeacon());
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
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => activeLocationRepository.enterBusiness(beacon: any(named: "beacon")))
          .thenAnswer((_) async => _activeLocation);

        bloc.add(NewActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(addingLocations: [_activeLocation.business.location.beacon]);
        ActiveLocationState secondState = firstState.update(addingLocations: [], activeLocations: [_activeLocation]);
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation calls activeLocationRepository.enterBusiness",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => activeLocationRepository.enterBusiness(beacon: any(named: "beacon")))
          .thenAnswer((_) async => _activeLocation);

        bloc.add(NewActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      verify: (_){
        verify(() => activeLocationRepository.enterBusiness(beacon: any(named: "beacon"))).called(1);
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation does not change state or call activeLocationRepository.enterBusiness if activeLocations list contains activeLocation",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);

        return _baseState.update(activeLocations: [_activeLocation]);
      },
      act: (bloc) {
        bloc.add(NewActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() =>  activeLocationRepository.enterBusiness(beacon: any(named: "beacon")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation does not change state or call activeLocationRepository.enterBusiness if addingActiveLocations list contains activeLocation",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);

        return _baseState.update(addingLocations: [_activeLocation.business.location.beacon]);
      },
      act: (bloc) {
        bloc.add(NewActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () => [],
      verify: (_) {
        verifyNever(() =>  activeLocationRepository.enterBusiness(beacon: any(named: "beacon")));
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event NewActiveLocation on error changes state: [addingLocations: activeLocation], [addingLocations: empty, errorMessage: error]",
      build: () => activeLocationBloc,
      act: (bloc) {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => activeLocationRepository.enterBusiness(beacon: any(named: "beacon")))
          .thenThrow(const ApiException(error: "error"));

        bloc.add(NewActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(addingLocations: [_activeLocation.business.location.beacon]);
        ActiveLocationState secondState = firstState.update(addingLocations: [], errorMessage: "error");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation changes state: [removingLocation: activeLocation], [activeLocations: [], removingLocation: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => true);

        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.business.location.beacon]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], activeLocations: []);
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation calls activeLocationRepository.exitBusiness",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => true);

        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
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
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
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
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(removingLocations: [_activeLocation.business.location.beacon]);
        return _baseState;
      },
      act: (bloc) {
        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
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
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenAnswer((_) async => false);

        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.business.location.beacon]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], errorMessage: "Unable to remove active location.");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event RemoveActiveLocation on error changes state: [removingLocation: activeLocation], [errorMessage: error, removingLocation: empty]",
      build: () => activeLocationBloc,
      seed: () {
        _activeLocation = MockActiveLocation();
        _business = MockDataGenerator().createBusiness();
        when(() => _activeLocation.business).thenReturn(_business);
        when(() => _activeLocation.identifier).thenReturn(faker.guid.guid());

        _baseState = _baseState.update(activeLocations: [_activeLocation]);
        return _baseState;
      },
      act: (bloc) {
        when(() => activeLocationRepository.exitBusiness(activeLocationId: any(named: "activeLocationId")))
          .thenThrow(const ApiException(error: "error occurred"));

        bloc.add(RemoveActiveLocation(beacon: _activeLocation.business.location.beacon));
      },
      expect: () {
        ActiveLocationState firstState = _baseState.update(removingLocations: [_activeLocation.business.location.beacon]);
        ActiveLocationState secondState = firstState.update(removingLocations: [], errorMessage: "error occurred");
        return [firstState, secondState];
      }
    );

    blocTest<ActiveLocationBloc, ActiveLocationState>(
      "ActiveLocationBloc event TransactionAdded yields state: [activeLocations: newActiveLocations]",
      build: () => activeLocationBloc,
      seed: () {
        _business = MockDataGenerator().createBusiness();
        _activeLocation = ActiveLocation(
          identifier: faker.guid.guid(),
          business: _business,
          transactionIdentifier: null,
          lastNotification: null
        );

        ActiveLocation otherLocation = ActiveLocation(
          identifier: faker.guid.guid(),
          business: MockDataGenerator().createBusiness(),
          transactionIdentifier: null,
          lastNotification: null
        );

        _baseState = _baseState.update(activeLocations: [_activeLocation, otherLocation]);
        return _baseState;
      },
      act: (bloc) => bloc.add(TransactionAdded(business: _activeLocation.business, transactionIdentifier: 'transactionIdentifier')),
      expect: () {
        List<ActiveLocation> updatedActiveLocations = _baseState.activeLocations.where((location) => location.identifier != _activeLocation.identifier).toList();
        return [_baseState.update(activeLocations: updatedActiveLocations + [_activeLocation.update(transactionIdentifier: "transactionIdentifier")])];
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