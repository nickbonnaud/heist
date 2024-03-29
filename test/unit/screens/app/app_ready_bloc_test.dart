import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/authentication/authentication_bloc.dart';
import 'package:heist/blocs/beacon/beacon_bloc.dart';
import 'package:heist/blocs/customer/customer_bloc.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';
import 'package:heist/models/status.dart';
import 'package:heist/app/bloc/app_ready_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockBeaconBloc extends Mock implements BeaconBloc {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}
class MockPermissionsBloc extends Mock implements PermissionsBloc {}
class MockCustomerBloc extends Mock implements CustomerBloc {}

void main() {
  group("App Ready Bloc Tests", () {
    late AuthenticationBloc authenticationBloc;
    late OpenTransactionsBloc openTransactionsBloc;
    late BeaconBloc beaconBloc;
    late NearbyBusinessesBloc nearbyBusinessesBloc;
    late PermissionsBloc permissionsBloc;
    late CustomerBloc customerBloc;

    late MockDataGenerator _mockDataGenerator;

    late AppReadyBloc appReadyBloc;

    late AppReadyState _baseState;

    setUp(() {
      authenticationBloc = MockAuthenticationBloc();
      whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([]));

      openTransactionsBloc = MockOpenTransactionsBloc();
      whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([]));

      beaconBloc = MockBeaconBloc();
      whenListen(beaconBloc, Stream<BeaconState>.fromIterable([]));

      nearbyBusinessesBloc = MockNearbyBusinessesBloc();
      whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([]));

      permissionsBloc = MockPermissionsBloc();
      whenListen(permissionsBloc,  Stream<PermissionsState>.fromIterable([]));

      customerBloc = MockCustomerBloc();
      whenListen(customerBloc,  Stream<CustomerState>.fromIterable([]));

      _mockDataGenerator = MockDataGenerator();

      appReadyBloc = AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      _baseState = appReadyBloc.state;
    });

    tearDown(() {
      appReadyBloc.close();
    });

    test("Initial state of AppReadyBloc is AppReadyState.initial()", () {
      expect(appReadyBloc.state, AppReadyState.initial());
    });

    test("AppReadyBloc has correct getters", () {
      expect(appReadyBloc.isDataLoaded, isA<bool>());
      expect(appReadyBloc.arePermissionChecksComplete, isA<bool>());
      expect(appReadyBloc.arePermissionsReady, isA<bool>());
      expect(appReadyBloc.areBusinessesLoaded, isA<bool>());
      expect(appReadyBloc.areBeaconsLoaded, isA<bool>());
      expect(appReadyBloc.areOpenTransactionsLoaded, isA<bool>());
      expect(appReadyBloc.isCustomerOnboarded, isA<bool>());
    });

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc CustomerStatusChanged event changes state [customerOnboarded: true]",
      build: () => appReadyBloc,
      act: (bloc) => bloc.add(const CustomerStatusChanged(customerStatus: Status(name: "name", code: 200))),
      expect: () => [_baseState.update(customerOnboarded: true)]
    );
    
    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc customerBlocSubscription => [customerState.customer != null] changes state [customerOnboarded: true]",
      build: () {
        var customer = _mockDataGenerator.createCustomer().update(status: const Status(name: "name", code: 200));
        CustomerState customerState = CustomerState(customer: customer, loading: false, errorMessage: "");
        whenListen(customerBloc, Stream<CustomerState>.fromIterable([customerState]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(customerOnboarded: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc customerBlocSubscription => [customerState.customer == null] does not change state",
      build: () {
        CustomerState customerState = const CustomerState(loading: false, errorMessage: "");
        whenListen(customerBloc, Stream<CustomerState>.fromIterable([customerState]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => []
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc PermissionChecksComplete event changes state [permissionChecksComplete: true, permissionsReady: true]",
      build: () => appReadyBloc,
      act: (bloc) => bloc.add(const PermissionChecksComplete(permissionsReady: true)),
      expect: () => [_baseState.update(permissionChecksComplete: true, permissionsReady: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc permissionsBlocSubscription => [!this.arePermissionChecksComplete && state.checksComplete] changes state [permissionChecksComplete: true, permissionsReady: true]",
      build: () {
        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([const PermissionsState(bleEnabled: true, locationEnabled: true, notificationEnabled: true, beaconEnabled: true, checksComplete: true)]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(permissionChecksComplete: true, permissionsReady: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc permissionsBlocSubscription => [!this.arePermissionChecksComplete && !state.checksComplete] does not change state",
      build: () {
        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([const PermissionsState(bleEnabled: true, locationEnabled: true, notificationEnabled: true, beaconEnabled: false, checksComplete: false)]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => []
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc AuthCheckComplete event changes state [authCheckComplete: true, isAuthenticated: true]",
      build: () => appReadyBloc,
      act: (bloc) => bloc.add(const AuthCheckComplete(isAuthenticated: true)),
      expect: () => [_baseState.update(authCheckComplete: true, isAuthenticated: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc authenticationBlocSubscription => [Unknown, (Unauthenticated || Authenticated)] changes state [authCheckComplete: true, isAuthenticated: true]",
      build: () {
        whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([Unknown(), const Authenticated()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(authCheckComplete: true, isAuthenticated: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc authenticationBlocSubscription => [Authenticated, Authenticated)] changes state once",
      build: () {
        whenListen(authenticationBloc, Stream<AuthenticationState>.fromIterable([const Authenticated(), const Authenticated()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(authCheckComplete: true, isAuthenticated: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc DataLoaded event changes state [openTransactionsLoaded: true], [nearbyBusinessesLoaded: true], [beaconsLoaded: true]",
      build: () => appReadyBloc,
      act: (bloc) {
        bloc.add(const DataLoaded(type: DataType.transactions));
        bloc.add(const DataLoaded(type: DataType.businesses));
        bloc.add(const DataLoaded(type: DataType.beacons));
      },
      expect: () {
        var firstState = _baseState.update(openTransactionsLoaded: true);
        var secondState = firstState.update(nearbyBusinessesLoaded: true);
        var thirdState = secondState.update(beaconsLoaded: true);

        return [firstState, secondState, thirdState];
      }
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc openTransactionsBlocSubscription => [!openTransactionsLoaded && OpenTransactionsLoaded || FailedToFetchOpenTransactions] changes state [openTransactionsLoaded: true]",
      build: () {
        whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([const OpenTransactionsLoaded(transactions: [])]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(openTransactionsLoaded: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc openTransactionsBlocSubscription => [Uninitialized] does not change state",
      build: () {
        whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([Uninitialized()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => []
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc beaconBlocSubscription => [!this.areBeaconsLoaded && state is Monitoring] changes state [beaconsLoaded: true]",
      build: () {
        whenListen(beaconBloc, Stream<BeaconState>.fromIterable([Monitoring()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(beaconsLoaded: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc beaconBlocSubscription => [!this.areBeaconsLoaded && state is BeaconUninitialized] does not change state",
      build: () {
        whenListen(beaconBloc, Stream<BeaconState>.fromIterable([BeaconUninitialized()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => []
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc nearbyBusinessesBlocSubscription => [!this.areBusinessesLoaded && (state is NearbyBusinessLoaded || state is FailedToLoadNearby)] changes state [nearbyBusinessesLoaded: true]",
      build: () {
        whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([const NearbyBusinessLoaded(businesses: [], preMarkers: [])]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => [_baseState.update(nearbyBusinessesLoaded: true)]
    );

    blocTest<AppReadyBloc, AppReadyState>(
      "AppReadyBloc nearbyBusinessesBlocSubscription => [!this.areBusinessesLoaded && NearbyUninitialized] does not change state",
      build: () {
        whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([NearbyUninitialized()]));
        return AppReadyBloc(authenticationBloc: authenticationBloc, openTransactionsBloc: openTransactionsBloc, beaconBloc: beaconBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, permissionsBloc: permissionsBloc, customerBloc: customerBloc);
      },
      expect: () => []
    );
  });
}