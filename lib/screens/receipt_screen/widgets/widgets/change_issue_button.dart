import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/screens/issue_screen/issue_screen.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Options {
  cancel,
  changeToWrongBill,
  changeToErrorInBill,
  changeToOther
}

class ChangeIssueButton extends StatelessWidget {
  final TransactionResource _transaction;
  final TransactionIssueRepository _transactionIssueRepository;

  ChangeIssueButton({required TransactionResource transaction, required TransactionIssueRepository transactionIssueRepository})
    : _transaction = transaction,
      _transactionIssueRepository = transactionIssueRepository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: PopupMenuButton(
        key: Key("changeIssueButtonKey"),
        onSelected: (Options selection) => _filterSelection(selection: selection, context: context),
        icon: Icon(
          Icons.more_vert,
          size: 40.w,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
          if (_transaction.transaction.status.code != 500)
            PopupMenuItem<Options>(
              child: _createTile(
                context: context,
              title: "Change to Wrong Bill"
              ),
              value: Options.changeToWrongBill,
            ),
          if (_transaction.transaction.status.code != 501)
            PopupMenuItem<Options>(
              child: _createTile(
                context: context,
                title: "Change to Error in Bill"
              ),
              value: Options.changeToErrorInBill,
            ),
          if (_transaction.transaction.status.code != 503)
            PopupMenuItem<Options>(
              child: _createTile(
                context: context,
                title: "Change to Other"
              ),
              value: Options.changeToOther,
            ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: "Cancel Issue"
            ),
            value: Options.cancel,
          ),
        ]
      ),
    );
  }

  _filterSelection({required Options selection, required BuildContext context}) async {
    IssueType type;
    switch (selection) {
      case Options.changeToWrongBill:
        type = IssueType.wrong_bill;
        break;
      case Options.changeToErrorInBill:
        type = IssueType.error_in_bill;
        break;
      case Options.changeToOther:
        type = IssueType.other;
        break;
      case Options.cancel:
        type = IssueType.cancel;
        break;
    }

    final TransactionResource? transaction = await showPlatformModalSheet(
      context: context, 
      builder: (_) => IssueScreen(
        type: type,
        transaction: _transaction,
        issueRepository: _transactionIssueRepository,
      )
    );
    if (transaction != null) {
      BlocProvider.of<ReceiptScreenBloc>(context).add(TransactionChanged(transactionResource: transaction));
    }
  }

  ListTile _createTile({required BuildContext context, required String title}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp
        ),
      )
    );
  }
}