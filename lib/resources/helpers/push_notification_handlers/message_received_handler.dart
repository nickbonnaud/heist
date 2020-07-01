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

  Future<void> init({@required BuildContext context, @required OSNotification oSNotification}) async {
    PushNotification notification = PushNotification.fromOsNotification(notification: oSNotification);
    
    if (notification.type != NotificationType.enter) {
      TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
      transactionResource = await _updateStatus(context: context, transactionResource: transactionResource, notification: notification);
      
      if (notification.type == NotificationType.auto_paid) {
        BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: transactionResource));
      } else {
        BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: transactionResource));
      }
    }
  }

  Future<TransactionResource> _updateStatus({@required BuildContext context, @required TransactionResource transactionResource, @required PushNotification notification}) async {
    Status status = _getStatus(notification: notification);
    if (notification.type != NotificationType.fix_bill) {
      if (transactionResource.transaction.status.code != status.code) {
        return transactionResource.update(transaction: transactionResource.transaction.update(status: status));
      }
      return transactionResource;
    } else {
      if (transactionResource.transaction.status.code < 500) {
        return await _fetchNewTransaction(context: context, notification: notification);
      }
      return transactionResource.update(issue: transactionResource.issue.update(warningsSent: notification.warningsSent));
    }
  }

  Status _getStatus({@required PushNotification notification}) {
    Status status;
    switch (notification.type) {
      case NotificationType.exit:
        status = Status(name: 'keep open notification sent', code: 105);
        break;
      case NotificationType.bill_closed:
        status = Status(name: 'bill closed', code: 101);
        break;
      case NotificationType.auto_paid:
        status = Status(name: 'payment processing', code: 103);
        break;
      case NotificationType.fix_bill:
        status = Status(name: 'other error', code: 503);
        break;
      case NotificationType.enter:
        status = null;
    }
    return status;
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
      return _fetchNewTransaction(context: context, notification: notification);
    }
    return transactionResource;
  }

  Future<TransactionResource> _fetchNewTransaction({@required BuildContext context, @required PushNotification notification}) async {
    PaginateDataHolder data = await _transactionRepository.fetchByIdentifier(nextPage: 1, identifier: notification.transactionIdentifier);
    return data.data[0];
  }
}