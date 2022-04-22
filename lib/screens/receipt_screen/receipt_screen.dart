import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import 'bloc/receipt_screen_bloc.dart';

class ReceiptScreen extends StatefulWidget {
  final TransactionResource _transactionResource;
  final bool _showAppBar;

  const ReceiptScreen({
    required TransactionResource transactionResource,
    bool showAppBar = true,
    Key? key
  })
    : _transactionResource = transactionResource,
      _showAppBar = showAppBar,
      super(key: key);

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  late ReceiptModalSheetBloc _receiptModalSheetBloc;
  
  @override
  void initState() {
    super.initState();
    _receiptModalSheetBloc = BlocProvider.of<ReceiptModalSheetBloc>(context);
    _receiptModalSheetBloc.add(Toggle());
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptScreenBloc>(
      create: (BuildContext context) => ReceiptScreenBloc(
        transactionResource: widget._transactionResource
      ),
      child: ReceiptScreenBody(showAppBar: widget._showAppBar)
    );
  }

  @override
  void dispose() {
    _receiptModalSheetBloc.add(Toggle());
    super.dispose();
  }
}