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

    late NotificationBootState _baseState;

    setUp(() {
      final PermissionsBloc permissionsBloc = MockPermissionsBloc();
      whenListen(permissionsBloc, Stream<PermissionsState>.fromIterable([]));
      
      final NearbyBusinessesBloc nearbyBusinessesBloc = MockNearbyBusinessesBloc();
      whenListen(nearbyBusinessesBloc, Stream<NearbyBusinessesState>.fromIterable([]));

      final OpenTransactionsBloc openTransactionsBloc = MockOpenTransactionsBloc();
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
  });
}