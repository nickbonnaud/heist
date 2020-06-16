import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import 'bloc/receipt_screen_bloc.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionResource _transactionResource;
  final bool _showAppBar;

  ReceiptScreen({@required TransactionResource transactionResource, bool showAppBar = true})
    : assert(transactionResource != null),
      _transactionResource = transactionResource,
      _showAppBar = showAppBar;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReceiptScreenBloc>(
      create: (BuildContext context) => ReceiptScreenBloc(transactionResource: _transactionResource),
      child: ReceiptScreenBody(showAppBar: _showAppBar,),
    );
  }

  
}