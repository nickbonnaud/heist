import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ActionButtonHandler {
  final TransactionRepository _transactionRepository = TransactionRepository();

  void init({@required BuildContext context, @required OSNotificationOpenedResult interaction}) {
    PushNotification notification = PushNotification.fromOsNotificationOpened(interaction: interaction);
    switch (interaction.action.actionId) {
      case 'view_bill':
        _handleViewBill(context: context, notification: notification);
        break;
      case 'keep_open':
        _handleKeepBillOpen(context: context, notification: notification);
        break;
      case 'pay':
        _handlePay(context: context, notification: notification);
        break;
      case 'call':
        _handleCall(context: context, notification: notification);
        break;
      default:
    }
  }

  void _handleViewBill({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    switch (notification.type) {
      case NotificationType.exit:
        transactionResource = _updateTransaction(context: context, transactionResource: transactionResource, name: 'keep open notification sent', code: 105, notification: notification);
        break;
      case NotificationType.auto_paid:
        transactionResource = _updateTransaction(context: context, transactionResource: transactionResource, name: 'payment processing', code: 103, notification: notification);
        break;
      case NotificationType.bill_closed:
        transactionResource = _updateTransaction(context: context, transactionResource: transactionResource, name: 'bill closed', code: 101, notification: notification);
        break;
      case NotificationType.fix_bill:
        if (transactionResource.transaction.status.code < 500) {
          transactionResource = await _fetchNetworkTransaction(context: context, notification: notification);
        } else {
          transactionResource = transactionResource.update(issue: transactionResource.issue.update(warningsSent: notification.warningsSent));
        }
        _updateTransaction(context: context, transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code, notification: notification);
        break;
      default:
        break;
    }
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  void _showReceiptScreen({@required BuildContext context, @required TransactionResource transactionResource}) {
    if (BlocProvider.of<ReceiptModalSheetBloc>(context).isVisible) Navigator.of(context).pop();
    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    );
  }

  void _handleKeepBillOpen({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource updatedTransaction = await _transactionRepository.keepBillOpen(transactionId: notification.transactionIdentifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: updatedTransaction));
  }

  void _handlePay({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource updatedTransaction = await _transactionRepository.approveTransaction(transactionId: notification.transactionIdentifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: updatedTransaction));
  }

  void _handleCall({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transaction = await _getTransaction(context: context, notification: notification);
    launch("tel://${transaction.business.profile.phone}");
  }
  
  Future<TransactionResource> _getTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(context: context, notification: notification);
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