import 'package:flutter_test/flutter_test.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/helpers/push_notification_handlers/message_received_handler.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mock_data_generator.dart';

class MockTransactionResource extends Mock implements TransactionResource {}
class MockTransactionRepository extends Mock implements TransactionRepository {}
class MockOpenTransactionsBloc extends Mock implements OpenTransactionsBloc {}

void main() {
  group("Message Received Handler Tests", () {
    late TransactionRepository transactionRepository;
    late OpenTransactionsBloc openTransactionsBloc;

    late MessageReceivedHandler messageReceivedHandler;

    late MockDataGenerator _mockDataGenerator;
    late TransactionResource _transactionResource;

    setUp(() {
      registerFallbackValue(RemoveOpenTransaction(transaction: MockTransactionResource()));
      registerFallbackValue(UpdateOpenTransaction(transaction: MockTransactionResource()));

      _mockDataGenerator = MockDataGenerator();
      _transactionResource = _mockDataGenerator.createTransactionResource();

      transactionRepository = MockTransactionRepository();
      openTransactionsBloc = MockOpenTransactionsBloc();

      messageReceivedHandler = MessageReceivedHandler(transactionRepository: transactionRepository, openTransactionsBloc: openTransactionsBloc);
    });

    void _init() {
      when(() => openTransactionsBloc.openTransactions)
        .thenReturn([_transactionResource]);

      when(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier")))
        .thenAnswer((_) async => PaginateDataHolder(data: [_transactionResource]));

      when(() => openTransactionsBloc.add(any(that: isA<OpenTransactionsEvent>())))
        .thenReturn(null);
    }

    test("MessageReceived Handler init calls openTransactionsBloc.openTransactions", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.openTransactions).called(1);
    });

    test("MessageReceived Handler init calls transactionRepository.fetchByIdentifier if transaction not present", () async {
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
      await messageReceivedHandler.init(notification: notification);

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("MessageReceived Handler init calls AddOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<AddOpenTransaction>()))).called(1);
    });

    test("MessageReceived Handler init can RemoveOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.auto_paid,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<RemoveOpenTransaction>()))).called(1);
    });

    test("MessageReceived Handler init can UpdateOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.exit,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
    });

    test("MessageReceived Handler init fix_bill calls transactionRepository.fetchByIdentifier if status code < 500", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.fix_bill,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => transactionRepository.fetchByIdentifier(identifier: any(named: "identifier"))).called(1);
    });

    test("MessageReceived Handler init fix_bill calls UpdateOpenTransaction", () async {
      final PushNotification notification = PushNotification(
        title: "title",
        body: "body",
        type: NotificationType.fix_bill,
        transactionIdentifier: _transactionResource.transaction.identifier,
        businessIdentifier: _transactionResource.business.identifier,
        warningsSent: null
      );

      _init();
      await messageReceivedHandler.init(notification: notification);

      verify(() => openTransactionsBloc.add(any(that: isA<UpdateOpenTransaction>()))).called(1);
    });
  });
}