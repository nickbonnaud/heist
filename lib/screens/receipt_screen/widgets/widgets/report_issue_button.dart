import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/issue_screen/models/issue_args.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum Options {
  wrongBill,
  errorInBill,
  otherError
}

class ReportIssueButton extends StatelessWidget {
  final TransactionResource _transaction;

  ReportIssueButton({required TransactionResource transaction})
    : _transaction = transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: PopupMenuButton(
        key: Key("reportIssueButtonKey"),
        onSelected: (Options selection) => _filterSelection(selection: selection, context: context),
        icon: Icon(
          Icons.more_vert,
          size: 40.w,
          color: Theme.of(context).colorScheme.topAppBarIcon,
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Wrong Bill'
            ),
            value: Options.wrongBill,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Error in Bill'
            ),
            value: Options.errorInBill,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              context: context,
              title: 'Other'
            ),
            value: Options.otherError,
          )
        ]
      ),
    );
  }

  _filterSelection({required Options selection, required BuildContext context}) async {
    IssueType type;
    switch (selection) {
      case Options.wrongBill:
        type = IssueType.wrong_bill;
        break;
      case Options.errorInBill:
        type = IssueType.error_in_bill;
        break;
      case Options.otherError:
        type = IssueType.other;
        break;
    }

    Navigator.of(context).pushNamed(Routes.reportIssue, arguments: IssueArgs(type: type, transactionResource: _transaction))
      .then((transactionResource) {
        if (transactionResource != null) {
          BlocProvider.of<ReceiptScreenBloc>(context).add(TransactionChanged(transactionResource: (transactionResource as TransactionResource)));
        }
    });
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