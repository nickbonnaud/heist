import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/bloc/receipt_modal_sheet_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
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
        transactionResource = _updateTransactionStatus(transactionResource: transactionResource, name: 'keep open notification sent', code: 105);
        break;
      case NotificationType.auto_paid:
        transactionResource = _updateTransactionStatus(transactionResource: transactionResource, name: 'payment processing', code: 103);
        break;
      case NotificationType.bill_closed:
        transactionResource = _updateTransactionStatus(transactionResource: transactionResource, name: 'bill closed', code: 101);
        break;
      case NotificationType.fix_bill:
        if (transactionResource.transaction.status.code < 500) {
          transactionResource = await _fetchNewTransaction(context: context, notification: notification);
        } else {
          transactionResource.update(issue: transactionResource.issue.update(warningsSent: notification.warningsSent));
        }
        break;
      default:
        break;
    }
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  TransactionResource _updateTransactionStatus({@required TransactionResource transactionResource, @required String name, @required int code}) {
    if (transactionResource.transaction.status.code != code) {
      return transactionResource.update(transaction: transactionResource.transaction.update(status: Status(name: name, code: code)));
    }
    return transactionResource;
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
    TransactionResource transactionResource = await _fetchTransaction(context: context, notification: notification);
    return transactionResource;
  }
  
  Future<TransactionResource> _fetchTransaction({@required BuildContext context, @required PushNotification notification}) async {
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