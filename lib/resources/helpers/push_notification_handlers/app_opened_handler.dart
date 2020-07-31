import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_type.dart';
import 'package:heist/screens/business_screen/business_screen.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class AppOpenedHandler {
  final TransactionRepository _transactionRepository = TransactionRepository();
  final BusinessRepository _businessRepository = BusinessRepository();

  void init({@required BuildContext context, @required OSNotificationOpenedResult interaction}) {
    PushNotification notification = PushNotification.fromOsNotificationOpened(interaction: interaction);
    switch (notification.type) {
      case NotificationType.enter:
        _handleEnter(context: context, notification: notification);
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

  void _handleEnter({@required BuildContext context, @required PushNotification notification}) async {
    Business business = BlocProvider.of<NearbyBusinessesBloc>(context).businesses
      .firstWhere((business) => notification.businessIdentifier == business.identifier,
      orElse: () => null
    );

    if (business == null) {
      List<Business> businesses = await _businessRepository.fetchByIdentifier(identifier: notification.businessIdentifier);
      business = businesses.first;
    }

    if (BlocProvider.of<ReceiptModalSheetBloc>(context).isVisible) Navigator.of(context).pop();
    showPlatformModalSheet(
      context: context, 
      builder: (_) => BusinessScreen(business: business)
    );
  }

  void _handleExit({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    transactionResource = _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'keep open notification sent', code: 105);
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  void _handleBillClosed({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    transactionResource = _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'bill closed', code: 101);
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  void _handleAutoPaid({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    transactionResource = _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: 'payment processing', code: 103);
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  void _handleFixBill({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    if (transactionResource.transaction.status.code < 500) {
      transactionResource = await _fetchNetworkTransaction(context: context, notification: notification);
    } else {
      transactionResource = transactionResource.update(issue: transactionResource.issue.update(warningsSent: notification.warningsSent));
    }
    _updateTransaction(notification: notification, context: context, transactionResource: transactionResource, name: transactionResource.transaction.status.name, code: transactionResource.transaction.status.code);
    _showReceiptScreen(context: context, transactionResource: transactionResource);
  }

  void _showReceiptScreen({@required BuildContext context, @required TransactionResource transactionResource}) {
    if (BlocProvider.of<ReceiptModalSheetBloc>(context).isVisible) Navigator.of(context).pop();
    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: transactionResource, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
    );
  }

  Future<TransactionResource> _getTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _fetchStoredTransaction(context: context, notification: notification);
    return transactionResource;
  }
  
  Future<TransactionResource> _fetchStoredTransaction({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = BlocProvider.of<OpenTransactionsBloc>(context).openTransactions
      .firstWhere((transaction) => notification.transactionIdentifier == transaction.transaction.identifier,
      orElse: () => null);

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