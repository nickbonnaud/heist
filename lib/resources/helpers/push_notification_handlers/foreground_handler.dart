
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_typ.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class ForegroundHandler {
  final TransactionRepository _transactionRepository = TransactionRepository();

  void init({@required BuildContext context, @required OSNotification oSNotification}) {
    PushNotification notification = PushNotification.fromOsNotification(notification: oSNotification);
    switch (notification.type) {
      case NotificationType.enter:
        _handleEnter(context: context, notification: notification);
        break;
      case NotificationType.exit:
        _handleExit(context: context, notification: notification);
        break;
      case NotificationType.request_payment:
        _handleRequestPayment(context: context, notification: notification);
        break;
      case NotificationType.auto_paid:
        _handleAutoPaid(context: context, notification: notification);
        break;
      case NotificationType.auto_paid_with_error:
        _handleAutoPaidWithError(context: context, notification: notification);
        break;
    }
  }


  void _handleEnter({@required BuildContext context, @required PushNotification notification}) {
    PlatformDialogAction action = PlatformDialogAction(
      child: PlatformText("OK"), 
      onPressed: () => Navigator.pop(context)
    );
    _showDialog(context: context, notification: notification, actions: [action]);
  }

  void _handleExit({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    List<PlatformDialogAction> actions = [];
    
    PlatformDialogAction viewAction = PlatformDialogAction(
      child: PlatformText("View Bill"), 
      onPressed: () => _showReceiptScreen(context: context, transactionResource: transactionResource)
    );
    actions.add(viewAction);

    if (!transactionResource.transaction.locked) {
      PlatformDialogAction keepBillOpenAction = PlatformDialogAction(
        child: PlatformText("Keep Bill Open"),
        onPressed: () => _keepBillOpen(context: context, transaction: transactionResource)
      );
      actions.add(keepBillOpenAction);
    }
    
    PlatformDialogAction payAction = PlatformDialogAction(
      child: PlatformText("Pay"), 
      onPressed: () => _payBill(context: context, transaction: transactionResource)
    );
    actions.add(payAction);
     _showDialog(context: context, notification: notification, actions: actions);    
  }

  void _handleRequestPayment({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);

    PlatformDialogAction viewAction = PlatformDialogAction(
      child: PlatformText("View Bill"), 
      onPressed: () => _showReceiptScreen(context: context, transactionResource: transactionResource)
    );

    PlatformDialogAction payAction = PlatformDialogAction(
      child: PlatformText("Pay"), 
      onPressed: () => _payBill(context: context, transaction: transactionResource)
    );

    _showDialog(context: context, notification: notification, actions: [viewAction, payAction]);
  }

  void _handleAutoPaid({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: transactionResource));

    PlatformDialogAction action = PlatformDialogAction(
      child: PlatformText("OK"), 
      onPressed: () => Navigator.pop(context)
    );
    _showDialog(context: context, notification: notification, actions: [action]);
  }

  void _handleAutoPaidWithError({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);

    PlatformDialogAction dismissAction = PlatformDialogAction(
      child: PlatformText("OK"), 
      onPressed: () => Navigator.pop(context)
    );
    
    PlatformDialogAction viewAction = PlatformDialogAction(
      child: PlatformText("View Bill"), 
      onPressed: () => _showReceiptScreen(context: context, transactionResource: transactionResource)
    );

    _showDialog(context: context, notification: notification, actions: [dismissAction, viewAction]);
  }
  

  void _payBill({@required BuildContext context, @required TransactionResource transaction}) async {
    TransactionResource updatedTransaction = await _transactionRepository.approveTransaction(transactionId: transaction.transaction.identifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: updatedTransaction));
  }
  
  void _keepBillOpen({@required BuildContext context, @required TransactionResource transaction}) async {
    TransactionResource updatedTransaction = await _transactionRepository.keepBillOpen(transactionId: transaction.transaction.identifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: updatedTransaction));
  }
  
  void _showDialog({@required BuildContext context, @required PushNotification notification, @required List<PlatformDialogAction> actions}) {
    showPlatformDialog(
      context: context, 
      builder: (_) => PlatformAlertDialog(
        title: PlatformText(notification.title),
        content: PlatformText(notification.body),
        actions: actions,
      )
    );
  }

  void _showReceiptScreen({@required BuildContext context, @required TransactionResource transactionResource}) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: transactionResource)
    );
  }
  
  Future<TransactionResource> _getTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchTransaction(context: context, notification: notification);
    BlocProvider.of<OpenTransactionsBloc>(context).add(AddOpenTransaction(transaction: transactionResource));
    return transactionResource;
  }
  
  Future<TransactionResource> _fetchTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = BlocProvider.of<OpenTransactionsBloc>(context).openTransactions
      .firstWhere((transaction) => notification.transactionIdentifier == transaction.transaction.identifier, 
      orElse: () =>  null
    );
    
    if (transactionResource == null) {
      PaginateDataHolder data = await _transactionRepository.fetchByIdentifier(nextPage: 1, identifier: notification.transactionIdentifier);
      return data.data[0];
    }
    return transactionResource;
  }

}