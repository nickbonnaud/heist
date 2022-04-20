import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/helpers/push_notification_handlers/app_opened_handler.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockNavigateTo extends Mock implements NavigateTo {}
class MockTransactionResource extends Mock implements TransactionResource {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockNotificationNavigationBloc extends Mock implements NotificationNavigationBloc {}
class MockBusinessRepository extends Mock implements BusinessRepository {}
class MockNearbyBusinessesBloc extends Mock implements NearbyBusinessesBloc {}

void main() {
  group("App Opened Handler Tests", () {
    late TransactionRepository transactionRepository;
    late OpenTransactionsBloc openTransactionsBloc;
    late NotificationNavigationBloc notificationNavigationBloc;
    late BusinessRepository businessRepository;
    late NearbyBusinessesBloc nearbyBusinessesBloc;

    late AppOpenedHandler appOpenedHandler;

    late MockDataGenerator _mockDataGenerator;
    late TransactionResource _transactionResource;
    late Business _business;

    setUp(() {
      registerFallbackValue(RemoveOpenTransaction(transaction: MockTransactionResource()));
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransactionResource()));
      registerFallbackValue(MockNavigateTo());

      _mockDataGenerator = MockDataGenerator();
      _transactionResource = _mockDataGenerator.createTransactionResource();
      _business = _mockDataGenerator.createBusiness();

      transactionRepository = MockTransactionRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();
      notificationNavigationBloc = MockNotificationNavigationBloc();
      businessRepository = MockBusinessRepository();
      nearbyBusinessesBloc = MockNearbyBusinessesBloc();

      appOpenedHandler = AppOpenedHandler(transactionRepository: transactionRepository, businessRepository: businessRepository, nearbyBusinessesBloc: nearbyBusinessesBloc, openTransactionsBloc: openTransactionsBloc, notificationNavigationBloc: notificationNavigationBloc);
    });

    void _init() {
      when(() => openTransactionsBloc.openTransactions)
        .thenReturn([_transactionResource]);

      when(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")))
        .thenAnswer((_) async => PaginateDataHolder(data: [_transactionResource]));

      when(() => notificationNavigationBloc.add(any(that: isA<NotificationNavigationEvent>())))
        .thenReturn(null);

      when(() => openTransactionsBloc.add(any(that: isA<OpenTransactionsEvent>())))
        .thenReturn(null);

      when(() => businessRepository.fetchByIdentifier(identifier: any(named: "identifier")))
        .thenAnswer((_) async => PaginateDataHolder(data: [_business]));

      when(() => nearbyBusinessesBloc.businesses)
        .thenReturn([_business]);
    }

    test("AppOpenedHandler init NotificationType.enter can view business screen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.enter,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => notificationNavigationBloc.add(any(that: isA<NavigateTo>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.enter calls nearbyBusinessesBloc.businesses", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.enter,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => nearbyBusinessesBloc.businesses).called(1);
    });

    test("AppOpenedHandler init NotificationType.enter calls businessRepository.fetchByIdentifier if business not present", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.enter,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      when(() => nearbyBusinessesBloc.businesses)
        .thenReturn([]);
      await appOpenedHandler.init(notification: notification);

      verify(() => businessRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("AppOpenedHandler init NotificationType.exit calls openTransactionsBloc.openTransactions", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.openTransactions).called(1);
    });

    test("AppOpenedHandler init NotificationType.exit calls transactionRepository.fetchByIdentifier if transaction not present", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      when(() => openTransactionsBloc.openTransactions)
        .thenReturn([]);

      await appOpenedHandler.init(notification: notification);

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("AppOpenedHandler init NotificationType.exit calls RemoveOpenTransaction if NotificationType.auto_paid", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.autoPaid,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.exit calls UpdateOpenTransaction if != NotificationType.auto_paid", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.exit shows receipt screen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => notificationNavigationBloc.add(any(that: isA<NavigateTo>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.bill_closed shows receipt screen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.billClosed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => notificationNavigationBloc.add(any(that: isA<NavigateTo>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.auto_paid shows receipt screen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.autoPaid,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => notificationNavigationBloc.add(any(that: isA<NavigateTo>()))).called(1);
    });

    test("AppOpenedHandler init NotificationType.fix_bill shows receipt calls transactionRepository.fetchByIdentifier if status.code < 500", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.fixBill,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("AppOpenedHandler init NotificationType.fix_bill shows receipt screen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.fixBill,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await appOpenedHandler.init(notification: notification);

      verify(() => notificationNavigationBloc.add(any(that: isA<NavigateTo>()))).called(1);
    });
  });
}