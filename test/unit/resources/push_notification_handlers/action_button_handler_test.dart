import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/helpers/external_url_handler.dart';
import 'package:heist/resources/helpers/push_notification_handlers/action_button_handler.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockNotificationNavigationBloc extends Mock implements NotificationNavigationBloc {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}
class MockTransactionResource extends Mock implements TransactionResource {}
class MockNavigateTo extends Mock implements NavigateTo {}
class MockExternalUrlHandler extends Mock implements ExternalUrlHandler {}

void main() {
  group("Action Button Handler Tests", () {
    late TransactionRepository transactionRepository;
    late OpenTransactionsBloc openTransactionsBloc;
    late NotificationNavigationBloc notificationNavigationBloc;
    late ExternalUrlHandler externalUrlHandler;

    late ActionButtonHandler actionButtonHandler;

    late MockDataGenerator _mockDataGenerator;
    late TransactionResource _transactionResource;

    setUp(() async {
      registerFallbackValue(RemoveOpenTransaction(transaction: MockTransactionResource()));
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransactionResource()));
      registerFallbackValue(MockNavigateTo());

      _mockDataGenerator = MockDataGenerator();
      _transactionResource = _mockDataGenerator.createTransactionResource();

      transactionRepository = MockTransactionRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();
      notificationNavigationBloc = MockNotificationNavigationBloc();
      externalUrlHandler = MockExternalUrlHandler();
      
      actionButtonHandler = ActionButtonHandler(
        transactionRepository: transactionRepository,
        openTransactionsBloc: openTransactionsBloc,
        notificationNavigationBloc: notificationNavigationBloc,
        externalUrlHandler: externalUrlHandler
      );
    });

    void _init() async {
      when(() => openTransactionsBloc.openTransactions)
        .thenReturn([_transactionResource]);
        
      when(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")))
        .thenAnswer((_) async => PaginateDataHolder(data: [_transactionResource]));
      when(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => _transactionResource);
      when(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId")))
        .thenAnswer((_) async => _transactionResource);

      when(() => notificationNavigationBloc.add(any(that: isA<NotificationNavigationEvent>())))
        .thenReturn(null);

      when(() => openTransactionsBloc.add(any(that: isA<OpenTransactionsEvent>())))
        .thenReturn(null);

      when(() => externalUrlHandler.go(url: any(named: "url")))
        .thenAnswer((_) async => null);
    }
    
    test("ActionButtonHandler init can view bill", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => notificationNavigationBloc.add(any(that: isA<NotificationNavigationEvent>()))).called(1);
    });

    test("ActionButtonHandler init view_bill fetches stored transaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => openTransactionsBloc.openTransactions).called(1);
    });

    test("ActionButtonHandler init view_bill does not fetch network transaction if stored", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verifyNever(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")));
    });

    test("ActionButtonHandler init view_bill fetches network transaction if not stored", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      when(() => openTransactionsBloc.openTransactions)
        .thenReturn([]);
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("ActionButtonHandler init view_bill calls RemoveOpenTransaction if NotificationType.auto_paid", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.auto_paid,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>()))).called(1);
    });

    test("ActionButtonHandler init view_bill calls UpdateOpenTransaction if != NotificationType.auto_paid", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
    });

    test("ActionButtonHandler init view_bill calls transactionRepository.fetchByIdentifier if NotificationType.fix_bill && status.code < 500", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.fix_bill,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "view_bill");

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("ActionButtonHandler init keep_open calls transactionRepository.keepBillOpen", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "keep_open");

      verify(() => transactionRepository.keepBillOpen(transactionId: any(named: "transactionId"))).called(1);
    });

    test("ActionButtonHandler init keep_open calls UpdateOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "keep_open");

      verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
    });

    test("ActionButtonHandler init pay calls transactionRepository.approveTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "pay");

      verify(() => transactionRepository.approveTransaction(transactionId: any(named: "transactionId"))).called(1);
    });

    test("ActionButtonHandler init pay calls RemoveOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "pay");

      verify(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>()))).called(1);
    });

    test("ActionButtonHandler init call calls openTransactionsBloc.openTransactions", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "call");

      verify(() => openTransactionsBloc.openTransactions).called(1);
    });

    test("ActionButtonHandler init call calls externalUrlHandler.go", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.bill_closed,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await actionButtonHandler.init(notification: notification, actionId: "call");

      verify(() => externalUrlHandler.go(url: any(named: "url"))).called(1);
    });
  });
}