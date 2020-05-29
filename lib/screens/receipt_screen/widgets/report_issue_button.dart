import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/enums/issue_type.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/issue_screen/issue_screen.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';

enum Options {
  wrongBill,
  errorInBill,
  otherError
}

class ReportIssueButton extends StatelessWidget {
  final TransactionResource _transaction;

  ReportIssueButton({@required TransactionResource transaction})
    : assert(transaction != null),
      _transaction = transaction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: PopupMenuButton(
        onSelected: (Options selection) => _filterSelection(selection: selection, context: context),
        icon: PlatformWidget(
          android: (_) => Icon(
            Icons.more_vert,
            size: SizeConfig.getWidth(10),
            color: Colors.black,
          ),
          ios: (_) => Icon(
            IconData(
              0xF397,
              fontFamily: CupertinoIcons.iconFont,
              fontPackage: CupertinoIcons.iconFontPackage,
            ),
            size: SizeConfig.getWidth(10),
            color: Colors.black,
          ),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Options>>[
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Wrong Bill'
            ),
            value: Options.wrongBill,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Error in Bill'
            ),
            value: Options.errorInBill,
          ),
          PopupMenuItem<Options>(
            child: _createTile(
              title: 'Other'
            ),
            value: Options.otherError,
          )
        ]
      ),
    );
  }

  _filterSelection({@required Options selection, @required BuildContext context}) async {
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

    TransactionResource transactionResource = await showPlatformModalSheet(
      context: context, 
      builder: (_) => IssueScreen(type: type, transaction: _transaction)
    );

    if (transactionResource != null) {
      BlocProvider.of<ReceiptScreenBloc>(context).add(TransactionChanged(transactionResource: transactionResource));
    }
  }

  ListTile _createTile({@required String title}) {
    return ListTile(
      title: _createTitle(title: title),
    );
  }

  Widget _createTitle({@required String title}) {
    return BoldText(text: title, size: SizeConfig.getWidth(4), color: Colors.black);
  }
}