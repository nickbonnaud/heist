import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import 'bloc/receipt_screen_bloc.dart';

class ReceiptScreen extends StatefulWidget {
  final TransactionResource _transactionResource;
  final bool _showAppBar;
  final ReceiptModalSheetBloc _receiptModalSheetBloc;

  ReceiptScreen({@required TransactionResource transactionResource, @required ReceiptModalSheetBloc receiptModalSheetBloc, bool showAppBar = true})
    : assert(transactionResource != null),
      _transactionResource = transactionResource,
      _receiptModalSheetBloc = receiptModalSheetBloc,
      _showAppBar = showAppBar;

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {

  @override
  void initState() {
    super.initState();
    widget._receiptModalSheetBloc.add(Toggle());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptScreenBloc>(
      create: (BuildContext context) => ReceiptScreenBloc(transactionResource: widget._transactionResource),
      child: ReceiptScreenBody(showAppBar: widget._showAppBar)
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._receiptModalSheetBloc.add(Toggle());
  }
}