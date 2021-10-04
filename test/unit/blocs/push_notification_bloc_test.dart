import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_boot/notification_boot_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/push_notification/push_notification_bloc.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/push_notification_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/helpers/external_url_handler.dart';
import 'package:mocktail/mocktail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MockPushNotificationRepository extends Mock implements PushNotificationRepository {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockNotificationBootBloc extends Mock implements NotificationBootBloc {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockNotificationNavigationBloc extends Mock implements NotificationNavigationBloc {}
class MockExternalUrlHandler extends Mock implements ExternalUrlHandler {}

void main() {
  group("Push Notification Bloc Tests", () {
    late PushNotificationRepository pushNotificationRepository;
    late NotificationBootBloc notificationBootBloc;
    late PushNotificationBloc pushNotificationBloc;

    setUp(() {
      pushNotificationRepository = MockPushNotificationRepository();
      when(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction")))
        .thenReturn(null);

      notificationBootBloc = MockNotificationBootBloc();
      whenListen(notificationBootBloc, Stream<NotificationBootState>.fromIterable([]));

      pushNotificationBloc = PushNotificationBloc(
        pushNotificationRepository: pushNotificationRepository,
        transactionRepository: MockTransactionRepository(),
        businessRepository: MockBusinessRepository(),
        notificationBootBloc: notificationBootBloc,
        nearbyBusinessesBloc: MockNearbyBusinessesBloc(),
        openTransactionsBloc: MockOpenTransactionsBloc(),
        notificationNavigationBloc: MockNotificationNavigationBloc(),
        externalUrlHandler: MockExternalUrlHandler()
      );
    });

    tearDown(() {
      pushNotificationBloc.close();
    });

    test("Initial state of PushNotificationBloc is PushNotificatinsUninitialized", () {
      expect(pushNotificationBloc.state, isA<PushNotificatinsUninitialized>());
    });

    blocTest<PushNotificationBloc, PushNotificationState>(
      "PushNotificationBloc StartPushNotificationMonitoring yields state: [MonitoringPushNotifications()]",
      build: () => pushNotificationBloc,
      act: (bloc) {
        when(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction")))
          .thenReturn(null);
        
        bloc.add(StartPushNotificationMonitoring(
          onMessageInteraction: ((OSNotificationOpenedResult notificationReceivedEvent) {}),
          onMessageReceived: ((OSNotificationReceivedEvent notificationReceivedEvent) {})
        ));
      },
      expect: () => [isA<MonitoringPushNotifications>()],
    );

    blocTest<PushNotificationBloc, PushNotificationState>(
      "PushNotificationBloc StartPushNotificationMonitoring calls pushNotificationRepository.startMonitoring",
      build: () => pushNotificationBloc,
      act: (bloc) {
        when(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction")))
          .thenReturn(null);
        
        bloc.add(StartPushNotificationMonitoring(
          onMessageInteraction: ((OSNotificationOpenedResult notificationReceivedEvent) {}),
          onMessageReceived: ((OSNotificationReceivedEvent notificationReceivedEvent) {})
        ));
      },
      verify: (_) {
        verify(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction"))).called(1);
      }
    );

    blocTest<PushNotificationBloc, PushNotificationState>(
      "PushNotificationBloc notificationBootBlocSubscription => [state.isReady] changes state [isA<MonitoringPushNotifications>()]",
      build: () {
        when(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction")))
          .thenReturn(null);

        whenListen(notificationBootBloc, Stream<NotificationBootState>.fromIterable([NotificationBootState(nearbyBusinessesReady: true, openTransactionsReady: true, permissionReady: true)]));

        return PushNotificationBloc(
          pushNotificationRepository: pushNotificationRepository,
          transactionRepository: MockTransactionRepository(),
          businessRepository: MockBusinessRepository(),
          notificationBootBloc: notificationBootBloc,
          nearbyBusinessesBloc: MockNearbyBusinessesBloc(),
          openTransactionsBloc: MockOpenTransactionsBloc(),
          notificationNavigationBloc: MockNotificationNavigationBloc(),
          externalUrlHandler: MockExternalUrlHandler()
        );
      },
      expect: () => [isA<MonitoringPushNotifications>()],
    );

    blocTest<PushNotificationBloc, PushNotificationState>(
      "PushNotificationBloc notificationBootBlocSubscription => [!state.isReady] does not change state",
      build: () {
        when(() => pushNotificationRepository.startMonitoring(onMessageReceived: any(named: "onMessageReceived"), onMessageInteraction: any(named: "onMessageInteraction")))
          .thenReturn(null);

        whenListen(notificationBootBloc, Stream<NotificationBootState>.fromIterable([NotificationBootState(nearbyBusinessesReady: true, openTransactionsReady: false, permissionReady: true)]));

        return PushNotificationBloc(
          pushNotificationRepository: pushNotificationRepository,
          transactionRepository: MockTransactionRepository(),
          businessRepository: MockBusinessRepository(),
          notificationBootBloc: notificationBootBloc,
          nearbyBusinessesBloc: MockNearbyBusinessesBloc(),
          openTransactionsBloc: MockOpenTransactionsBloc(),
          notificationNavigationBloc: MockNotificationNavigationBloc(),
          externalUrlHandler: MockExternalUrlHandler()
        );
      },
      expect: () => [],
    );
  });
}