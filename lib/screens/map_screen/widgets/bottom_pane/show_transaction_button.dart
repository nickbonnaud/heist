import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/bloc/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';

class ShowTransactionButton extends StatefulWidget {
  final TransactionResource _transaction;

  ShowTransactionButton({@required TransactionResource transaction})
    : assert(transaction != null),
      _transaction = transaction;

  @override
  State<ShowTransactionButton> createState() => _ShowTransactionButtonState();
}

class _ShowTransactionButtonState extends State<ShowTransactionButton> with SingleTickerProviderStateMixin {
  bool _buttonDown = false;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.0,
      upperBound: 0.3,
    )..addListener(() {
      setState(() {});
    });
    
    if ((widget._transaction.issue?.warningsSent ?? 0) != 0 && widget._transaction.transaction.status.code >= 500) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20, bottom: 10),
            child: Material(
              shape: CircleBorder(),
              elevation: _buttonDown ? 0 : 5,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget._transaction.business.photos.logo.smallUrl),
                radius: SizeConfig.getWidth(8),
              )
            ),
          ),
          if ((widget._transaction.issue?.warningsSent ?? 0) != 0 && widget._transaction.transaction.status.code >= 500)
            Positioned(
              bottom: 2.0,
              left: 10.0,
              child: _createWarningIcon()
            )
        ],
      ),
      onTapDown: (_) => setState(() {
        _buttonDown = true;
      }),
      onTapUp: (_) => setState(() {
        _buttonDown = false;
      }),
      onTap: () => showPlatformModalSheet(
        context: context,
        builder: (_) => ReceiptScreen(transactionResource: widget._transaction, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
      ).then((value) => setState(() {
        _buttonDown = false;
      }))
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _createWarningIcon() {
    return Transform.scale(
        scale: 1 - _controller.value,
        child: RawMaterialButton(
          onPressed: () => showPlatformModalSheet(
            context: context,
            builder: (_) => ReceiptScreen(transactionResource: widget._transaction, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context))
          ),
          child: Icon(
            Icons.priority_high,
            color: Colors.white,
          ),
          shape: CircleBorder(),
          elevation: _buttonDown ? 0 : 5,
          fillColor: widget._transaction.issue.warningsSent == 1
            ? Colors.orange 
            : widget._transaction.issue.warningsSent == 2 
            ? Colors.deepOrange[400]
            : Colors.red,
        )
        
      );
  }
}
