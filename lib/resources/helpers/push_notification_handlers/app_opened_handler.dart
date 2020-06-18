import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/nearby_businesses/nearby_businesses_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/business/business.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/status.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/notification_typ.dart';
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

  void _handleEnter({@required BuildContext context, @required PushNotification notification}) async {
    Business business = BlocProvider.of<NearbyBusinessesBloc>(context).businesses
      .firstWhere((business) => notification.businessIdentifier == business.identifier,
      orElse: () => null
    );

    if (business == null) {
      business =  await _businessRepository.fetchByIdentifier(identifier: notification.businessIdentifier);
    }

    showPlatformModalSheet(
      context: context, 
      builder: (_) => BusinessScreen(business: business)
    );
  }

  void _handleExit({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    if (transactionResource.transaction.status.code != 105) {
      TransactionResource transaction = transactionResource.update(transaction: transactionResource.transaction.update(status: Status(name: "keep open notification sent", code: 105)));
      BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: transaction));
      _showReceiptScreen(context: context, transactionResource: transaction, showAppBar: true);
    } else {
      _showReceiptScreen(context: context, transactionResource: transactionResource, showAppBar: true);
    }
  }

  void _handleRequestPayment({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _showReceiptScreen(context: context, transactionResource: transactionResource, showAppBar: true);
  }

  void _handleAutoPaid({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _showReceiptScreen(context: context, transactionResource: transactionResource, showAppBar: false);
  }

  void _handleAutoPaidWithError({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transactionResource = await _getTransaction(context: context, notification: notification);
    _showReceiptScreen(context: context, transactionResource: transactionResource, showAppBar: true);
  }



  
  void _keepBillOpen({@required BuildContext context, @required TransactionResource transaction}) async {
    TransactionResource updatedTransaction = await _transactionRepository.keepBillOpen(transactionId: transaction.transaction.identifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(UpdateOpenTransaction(transaction: updatedTransaction));
  }
  
  void _payBill({@required BuildContext context, @required TransactionResource transaction}) async {
    TransactionResource updatedTransaction = await _transactionRepository.approveTransaction(transactionId: transaction.transaction.identifier);
    BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: updatedTransaction));
  }
  
  void _showReceiptScreen({@required BuildContext context, @required TransactionResource transactionResource, @required bool showAppBar}) {
    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: transactionResource, showAppBar: showAppBar)
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