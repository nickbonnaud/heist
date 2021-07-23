import 'package:collection/collection.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';

class MessageReceivedHandler {
  final TransactionRepository _transactionRepository;
  final OpenTransactionsBloc _openTransactionsBloc;

  MessageReceivedHandler({
    required TransactionRepository transactionRepository,
    required OpenTransactionsBloc openTransactionsBloc,
  })
    : _transactionRepository = transactionRepository,
      _openTransactionsBloc = openTransactionsBloc;

  Future<void> init({required PushNotification notification}) async {
    switch (notification.type) {
      case NotificationType.enter:
        break;
      case NotificationType.exit:
        await _handleExit(notification: notification);
        break;
      case NotificationType.bill_closed:
        await _handleBillClosed(notification: notification);
        break;
      case NotificationType.auto_paid:
        await _handleAutoPaid(notification: notification);
        break;
      case NotificationType.fix_bill:
        await _handleFixBill(notification: notification);
        break;
      case NotificationType.other:
        break;
    }
  }

  Future<void> _handleExit({required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(notification: notification);
    _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'keep open notification sent', code: 105);
  }

  Future<void> _handleBillClosed({required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(notification: notification);
    _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'bill closed', code: 101);
  }

  Future<void> _handleAutoPaid({required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(notification: notification);
    _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'payment processing', code: 103);
  }

  Future<void> _handleFixBill({required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(notification: notification);
    if (transactionResource.transaction.status.code < 500) {
      transactionResource = await _fetchNetworkTransaction(notification: notification);
    } else {
      transactionResource = transactionResource.update(issue: transactionResource.issue!.update(warningsSent: notification.warningsSent));
    }
    _updateTransaction(notification: notification, transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code);
  }
  
  Future<TransactionResource> _getTransaction({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    _openTransactionsBloc.add(AddOpenTransaction(transaction: transactionResource));
    return transactionResource;
  }
  
  Future<TransactionResource> _fetchStoredTransaction({required PushNotification notification}) async {
    TransactionResource? transactionResource = _openTransactionsBloc.openTransactions
      .firstWhereOrNull((transaction) => notification.transactionIdentifier == transaction.transaction.identifier);
    
    if (transactionResource == null) {
      return _fetchNetworkTransaction(notification: notification);
    }
    return transactionResource;
  }

  Future<TransactionResource> _fetchNetworkTransaction({required PushNotification notification}) async {
    PaginateDataHolder data = await _transactionRepository.fetchByIdentifier(identifier: notification.transactionIdentifier!);
    return data.data[0];
  }

  TransactionResource _updateTransaction({required TransactionResource transactionResource, required String name, required int code, required PushNotification notification}) {
    if (transactionResource.transaction.status.code != code) {
      transactionResource = transactionResource.update(transaction: transactionResource.transaction.update(status: Status(name: name, code: code)));
    }

    if (notification.type == NotificationType.auto_paid) {
      _openTransactionsBloc.add(RemoveOpenTransaction(transaction: transactionResource));
    } else {
      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transactionResource));
    }
    return transactionResource;
  }
}