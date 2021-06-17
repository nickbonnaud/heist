import 'package:collection/collection.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/routing/routes.dart';

class AppOpenedHandler {
  final TransactionRepository _transactionRepository;
  final BusinessRepository _businessRepository;
  final NearbyBusinessesBloc _nearbyBusinessesBloc;
  final OpenTransactionsBloc _openTransactionsBloc;
  final NotificationNavigationBloc _notificationNavigationBloc;

  AppOpenedHandler({
    required TransactionRepository transactionRepository,
    required BusinessRepository businessRepository,
    required NearbyBusinessesBloc nearbyBusinessesBloc,
    required OpenTransactionsBloc openTransactionsBloc,
    required NotificationNavigationBloc notificationNavigationBloc
  })
    : _transactionRepository = transactionRepository,
      _businessRepository = businessRepository,
      _nearbyBusinessesBloc = nearbyBusinessesBloc,
      _openTransactionsBloc = openTransactionsBloc,
      _notificationNavigationBloc = notificationNavigationBloc;

  Future<void> init({required PushNotification notification}) async {
    switch (notification.type) {
      case NotificationType.enter:
        await _handleEnter(notification: notification);
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

  Future<void> _handleEnter({required PushNotification notification}) async {
    Business? business = _nearbyBusinessesBloc.businesses
      .firstWhereOrNull((business) => notification.businessIdentifier == business.identifier);

    if (business == null) {
      final PaginateDataHolder holder = await _businessRepository.fetchByIdentifier(identifier: notification.businessIdentifier!);
      business = holder.data.first;
    }

    _notificationNavigationBloc.add(NavigateTo(route: Routes.business, arguments: business));
  }

  Future<void> _handleExit({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    transactionResource = _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'keep open notification sent', code: 105);
    _showReceiptScreen(transactionResource: transactionResource);
  }

  Future<void> _handleBillClosed({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    transactionResource = _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'bill closed', code: 101);
    _showReceiptScreen( transactionResource: transactionResource);
  }

  Future<void> _handleAutoPaid({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    transactionResource = _updateTransaction(notification: notification, transactionResource: transactionResource, name: 'payment processing', code: 103);
    _showReceiptScreen(transactionResource: transactionResource);
  }

  Future<void> _handleFixBill({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    if (transactionResource.transaction.status.code < 500) {
      transactionResource = await _fetchNetworkTransaction(notification: notification);
    } else {
      transactionResource = transactionResource.update(issue: transactionResource.issue!.update(warningsSent: notification.warningsSent));
    }
    _updateTransaction(notification: notification, transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code);
    _showReceiptScreen(transactionResource: transactionResource);
  }

  void _showReceiptScreen({required TransactionResource transactionResource}) {
    _notificationNavigationBloc.add(NavigateTo(route: Routes.receipt, arguments: transactionResource));
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
    final PaginateDataHolder holder = await _transactionRepository.fetchByIdentifier(identifier: notification.transactionIdentifier!);
    return holder.data.first;
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