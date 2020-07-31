import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class MessageReceivedHandler {
  final TransactionRepository _transactionRepository = TransactionRepository();

  void init({@required BuildContext context, @required OSNotification oSNotification}) {
    PushNotification notification = PushNotification.fromOsNotification(notification: oSNotification);

    switch (notification.type) {
      case NotificationType.enter:
        break;
      case NotificationType.exit:
        _handleExit(context: context, notification: notification);
        break;
      case NotificationType.bill_closed:
        _handleBillClosed(context: context, notification: notification);
        break;
      case NotificationType.auto_paid:
        _handleAutoPaid(context: context, notification: notification);
        break;
      case NotificationType.fix_bill:
        _handleFixBill(context: context, notification: notification);
        break;
    }
  }

  void _handleExit({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'keep open notification sent', code: 105);
  }

  void _handleBillClosed({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'bill closed', code: 101);
  }

  void _handleAutoPaid({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'payment processing', code: 103);
  }

  void _handleFixBill({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    if (transactionResource.transaction.status.code < 500) {
      transactionResource = await _fetchNetworkTransaction(context: context, notification: notification);
    } else {
      transactionResource = transactionResource.update(issue: transactionResource.issue.update(warningsSent: notification.warningsSent));
    }
    _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code);
  }
  
  Future<TransactionResource> _getTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(context: context, notification: notification);
    BlocProvider.of<OpenTransactionsBloc>(context).add(AddOpenTransaction(transaction: transactionResource));
    return transactionResource;
  }
  
  Future<TransactionResource> _fetchStoredTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = BlocProvider.of<OpenTransactionsBloc>(context).openTransactions
      .firstWhere((transaction) => notification.transactionIdentifier == transaction.transaction.identifier, 
      orElse: () =>  null
    );
    
    if (transactionResource == null) {
      return _fetchNetworkTransaction(context: context, notification: notification);
    }
    return transactionResource;
  }

  Future<TransactionResource> _fetchNetworkTransaction({@required BuildContext context, @required PushNotification notification}) async {
    PaginateDataHolder data = await _transactionRepository.fetchByIdentifier(nextPage: 1, identifier: notification.transactionIdentifier);
    return data.data[0];
  }

  TransactionResource _updateTransaction({@required BuildContext context, @required TransactionResource transactionResource, @required String name, @required int code, @required PushNotification notification}) {
    if (transactionResource.transaction.status.code != code) {
      transactionResource = transactionResource.update(transaction: transactionResource.transaction.update(status: Status(name: name, code: code)));
    }

    if (notification.type == NotificationType.auto_paid) {
      BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: transactionResource));
    } else {
      BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: transactionResource));
    }
    return transactionResource;
  }
}