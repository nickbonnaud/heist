import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/permissions/permissions_bloc.dart';

class MockPermissionsBloc extends Mock implements PermissionsBloc {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}

void main() {
  group("Notification Boot Bloc Tests", () {
    late NotificationBootBloc notificationBootBloc;
    late PermissionsBloc permissionsBloc;
    late NearbyBusinessesBloc nearbyBusinessesBloc;
    late OpenTransactionsBloc openTransactionsBloc;

    late NotificationBootState _baseState;

    setUp(() {
      permissionsBloc = MockPermissionsBloc();
      whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([]));
      
      nearbyBusinessesBloc = MockNearbyBusinessesBloc();
      whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([]));

      openTransactionsBloc = MockOpenTransactionsBloc();
      whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([]));

      notificationBootBloc = NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      _baseState = notificationBootBloc.state;
    });

    tearDown(() {
      notificationBootBloc.close();
    });

    test("Initial state of NotificationBootBloc is NotificationBootState.initial()", () {
      expect(notificationBootBloc.state, NotificationBootState.initial());
    });

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc NearbyBusinessesReady event yields state: [nearbyBusinessesReady: true]",
      build: () => notificationBootBloc,
      act: (bloc) => bloc.add(NearbyBusinessesReady()),
      expect: () => [_baseState.update(nearbyBusinessesReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc OpenTransactionsReady event yields state: [openTransactionsReady: true]",
      build: () => notificationBootBloc,
      act: (bloc) => bloc.add(OpenTransactionsReady()),
      expect: () => [_baseState.update(openTransactionsReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc PermissionReady event yields state: [permissionReady: true]",
      build: () => notificationBootBloc,
      act: (bloc) => bloc.add(PermissionReady()),
      expect: () => [_baseState.update(permissionReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc permissionsBlocSubscription => [notificationEnabled] changes state [permissionReady: true]",
      build: () {
        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([PermissionsState.isInitial().update(notificationEnabled: true)]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => [_baseState.update(permissionReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc permissionsBlocSubscription => [!notificationEnabled] does not change state",
      build: () {
        whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([PermissionsState.isInitial()]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => []
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc nearbyBusinessesBlocSubscription => [NearbyBusinessLoaded] changes state [nearbyBusinessesReady: true]",
      build: () {
        whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([NearbyBusinessLoaded(businesses: [], preMarkers: [])]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => [_baseState.update(nearbyBusinessesReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc nearbyBusinessesBlocSubscription => [!NearbyBusinessLoaded] does not change state",
      build: () {
        whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([NearbyUninitialized()]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => []
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc openTransactionsBlocSubscription => [OpenTransactionsLoaded] changes state [openTransactionsReady: true]",
      build: () {
        whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([OpenTransactionsLoaded(transactions: [])]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => [_baseState.update(openTransactionsReady: true)]
    );

    blocTest<NotificationBootBloc, NotificationBootState>(
      "NotificationBootBloc openTransactionsBlocSubscription => [!OpenTransactionsLoaded] does not change state",
      build: () {
        whenListen(openTransactionsBloc, Stream<OpenTransactionsState>.fromIterable([Uninitialized()]));
        return NotificationBootBloc(permissionsBloc: permissionsBloc, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc);
      },
      expect: () => []
    );
  });
}