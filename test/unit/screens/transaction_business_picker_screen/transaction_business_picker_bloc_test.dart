import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/active_location/active_location_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/customer/active_location.dart';
import 'package:heist/screens/transaction_business_picker_screen/bloc/transaction_business_picker_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockActiveLocationBloc extends Mock implements ActiveLocationBloc {}

void main() {
  group("Transaction Business Picker Bloc Tests", () {
    late ActiveLocationBloc activeLocationBloc;

    late TransactionBusinessPickerBloc transactionBusinessPickerBloc;

    late TransactionBusinessPickerState _baseState;
    late List<Business> _nearbyLocations;
    late List<ActiveLocation> _activeLocations;

    setUp(() {
      _nearbyLocations = List<Business>.generate(10, (index) => MockDataGenerator().createBusiness());
      
      _activeLocations = List<ActiveLocation>.generate(3, (index) {
        return ActiveLocation(
          identifier: faker.guid.guid(),
          business: _nearbyLocations[index],
          transactionIdentifier: index == 1
            ? faker.guid.guid()
            : null,
          lastNotification: null
        );
      });
      
      activeLocationBloc = MockActiveLocationBloc();
      when(() => activeLocationBloc.state).thenReturn(ActiveLocationState(
        activeLocations: _activeLocations,
        addingLocations: [],
        removingLocations: [],
        errorMessage: ""
      ));
      whenListen(activeLocationBloc, Stream<ActiveLocationState>.fromIterable([]));

      transactionBusinessPickerBloc = TransactionBusinessPickerBloc(activeLocationBloc: activeLocationBloc);
      _baseState = transactionBusinessPickerBloc.state;
    });

    tearDown(() {
      transactionBusinessPickerBloc.close();
    });

    test("Initial state of TransactionBusinessPickerBloc is TransactionBusinessPickerState.initial()", () {
      expect(transactionBusinessPickerBloc.state, TransactionBusinessPickerState.initial());
    });

    blocTest<TransactionBusinessPickerBloc, TransactionBusinessPickerState>(
      "TransactionBusinessPickerBloc Init event yields state: [availableBusinesses: businesses]",
      build: () => transactionBusinessPickerBloc,
      act: (bloc) => bloc.add(Init(activeLocations: _activeLocations)),
      expect: () => [_baseState.update(availableBusinesses: [
        _nearbyLocations[0],
        _nearbyLocations[2]
      ])]
    );

    blocTest<TransactionBusinessPickerBloc, TransactionBusinessPickerState>(
      "TransactionBusinessPickerBloc ActiveLocationsChanged event yields state: [availableBusinesses: businesses]",
      build: () => transactionBusinessPickerBloc,
      seed: () {
        _baseState = _baseState.update(availableBusinesses: [
          _nearbyLocations[0],
          _nearbyLocations[2]
        ]);
        return _baseState;
      },
      act: (bloc) {
        
        bloc.add(ActiveLocationsChanged(activeLocations: [
          _activeLocations[0].update(transactionIdentifier: faker.guid.guid()),
          _activeLocations[1],
          _activeLocations[2]
        ]));
      },
      expect: () => [_baseState.update(availableBusinesses: [
        _nearbyLocations[2]
      ])]
    );

    blocTest<TransactionBusinessPickerBloc, TransactionBusinessPickerState>(
      "TransactionBusinessPickerBloc listens to activeLocationBloc",
      seed: () {
        _baseState = _baseState.update(availableBusinesses: [
          _nearbyLocations[0],
          _nearbyLocations[2]
        ]);
        return _baseState;
      },
      build: () {
        whenListen(activeLocationBloc, Stream<ActiveLocationState>.fromIterable([
          ActiveLocationState(
            activeLocations: [
              _activeLocations[0].update(transactionIdentifier: faker.guid.guid()),
              _activeLocations[1],
              _activeLocations[2]
            ],
            addingLocations: [],
            removingLocations: [],
            errorMessage: ""
          )
        ]));
        return TransactionBusinessPickerBloc(activeLocationBloc: activeLocationBloc);
      },
      expect: () => [_baseState.update(availableBusinesses: [
        _nearbyLocations[2]
      ])]
    );
  });
}