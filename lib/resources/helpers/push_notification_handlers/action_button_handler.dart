import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:heist/blocs/notification_navigation/notification_navigation_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/resources/helpers/external_url_handler.dart';
import 'package:heist/routing/routes.dart';
import 'package:meta/meta.dart';

@immutable
class ActionButtonHandler {
  final TransactionRepository _transactionRepository;
  final OpenTransactionsBloc _openTransactionsBloc;
  final NotificationNavigationBloc _notificationNavigationBloc;
  final ExternalUrlHandler _externalUrlHandler;

  const ActionButtonHandler({
    required TransactionRepository transactionRepository,
    required OpenTransactionsBloc openTransactionsBloc,
    required NotificationNavigationBloc notificationNavigationBloc,
    required ExternalUrlHandler externalUrlHandler
  })
    : _transactionRepository = transactionRepository,
      _openTransactionsBloc = openTransactionsBloc,
      _notificationNavigationBloc = notificationNavigationBloc,
      _externalUrlHandler = externalUrlHandler;

  Future<void> init({required PushNotification notification, required String actionId}) async {
    switch (actionId) {
      case 'view_bill':
        _handleViewBill(notification: notification);
        break;
      case 'keep_open':
        _handleKeepBillOpen(notification: notification);
        break;
      case 'pay':
        _handlePay(notification: notification);
        break;
      case 'call':
        _handleCall(notification: notification);
        break;
      default:
    }
  }

  Future<void> _handleViewBill({required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(notification: notification);
    switch (notification.type) {
      case NotificationType.exit:
        transactionResource = _updateTransaction(transactionResource: transactionResource, name: 'keep open notification sent', code: 105, notification: notification);
        break;
      case NotificationType.autoPaid:
        transactionResource = _updateTransaction(transactionResource: transactionResource, name: 'payment processing', code: 103, notification: notification);
        break;
      case NotificationType.billClosed:
        transactionResource = _updateTransaction(transactionResource: transactionResource, name: 'bill closed', code: 101, notification: notification);
        break;
      case NotificationType.fixBill:
        if (transactionResource.transaction.status.code < 500) {
          transactionResource = await _fetchNetworkTransaction(notification: notification);
        } else {
          transactionResource = transactionResource.update(issue: transactionResource.issue!.update(warningsSent: notification.warningsSent));
        }
        _updateTransaction(transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code, notification: notification);
        break;
      default:
        break;
    }
    _showReceiptScreen(transactionResource: transactionResource);
  }

  void _showReceiptScreen({required TransactionResource transactionResource}) {
    _notificationNavigationBloc.add(NavigateTo(route: Routes.receipt, arguments: transactionResource));
  }

  Future<void> _handleKeepBillOpen({required PushNotification notification}) async {
    TransactionResource updatedTransaction = await _transactionRepository.keepBillOpen(transactionId: notification.transactionIdentifier!);
    _openTransactionsBloc.add(UpdateOpenTransaction(transaction: updatedTransaction));
  }

  Future<void> _handlePay({required PushNotification notification}) async {
    TransactionResource updatedTransaction = await _transactionRepository.approveTransaction(transactionId: notification.transactionIdentifier!);
    _openTransactionsBloc.add(RemoveOpenTransaction(transaction: updatedTransaction));
  }

  Future<void> _handleCall({required PushNotification notification}) async {
    TransactionResource transaction = await _fetchStoredTransaction(notification: notification);
    _externalUrlHandler.go(url: "tel://${transaction.business.profile.phone}");
  }
  
  Future<TransactionResource> _fetchStoredTransaction({required PushNotification notification}) async {
    final TransactionResource? transactionResource = _openTransactionsBloc.openTransactions
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

    if (notification.type == NotificationType.autoPaid) {
      _openTransactionsBloc.add(RemoveOpenTransaction(transaction: transactionResource));
    } else {
      _openTransactionsBloc.add(UpdateOpenTransaction(transaction: transactionResource));
    }
    return transactionResource;
  }
}