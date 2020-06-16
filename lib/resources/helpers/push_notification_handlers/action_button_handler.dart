import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/paginate_data_holder.dart';
import 'package:heist/models/push_notification.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/screens/issue_screen/issue_screen.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
import 'package:meta/meta.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
      case 'report_issue':
        _handleReportIssue(context: context, notification: notification);
        break;
      default:
    }
  }

  void _handleViewBill({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transaction = await _getTransaction(context: context, notification: notification);

    showPlatformModalSheet(
      context: context, 
      builder: (_) => ReceiptScreen(transactionResource: transaction)
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

  void _handleReportIssue({@required BuildContext context, @required PushNotification notification}) async {
    TransactionResource transaction = await _getTransaction(context: context, notification: notification);

    showPlatformDialog(
      context: context, 
      builder: (_) => PlatformAlertDialog(
        title: PlatformText("Bill Issue"),
        content: PlatformText("Please Select an Issue."),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText("Wrong Bill"),
            onPressed: () => showPlatformModalSheet(
              context: context, 
              builder: (_) => IssueScreen(type: IssueType.wrong_bill, transaction: transaction)
            ),
          ),
          PlatformDialogAction(
            child: PlatformText("Error in Bill"),
            onPressed: () => showPlatformModalSheet(
              context: context, 
              builder: (_) => IssueScreen(type: IssueType.error_in_bill, transaction: transaction)
            ),
          ),
          PlatformDialogAction(
            child: PlatformText("Other"),
            onPressed: () => showPlatformModalSheet(
              context: context, 
              builder: (_) => IssueScreen(type: IssueType.other, transaction: transaction)
            ),
          ),
        ],
      )
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