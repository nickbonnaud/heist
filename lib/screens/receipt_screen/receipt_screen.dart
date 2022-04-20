import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/repositories/transaction_issue_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/receipt_screen/widgets/receipt_screen_body.dart';

import 'bloc/receipt_screen_bloc.dart';

class ReceiptScreen extends StatefulWidget {
  final TransactionResource _transactionResource;
  final bool _showAppBar;
  final ReceiptModalSheetBloc _receiptModalSheetBloc;
  final TransactionRepository _transactionRepository;
  final TransactionIssueRepository _transactionIssueRepository;
  final OpenTransactionsBloc _openTransactionsBloc;

  const ReceiptScreen({
    required TransactionResource transactionResource,
    required ReceiptModalSheetBloc receiptModalSheetBloc,
    required TransactionRepository transactionRepository,
    required TransactionIssueRepository transactionIssueRepository,
    required OpenTransactionsBloc openTransactionsBloc,
    bool showAppBar = true,
    Key? key
  })
    : _transactionResource = transactionResource,
      _receiptModalSheetBloc = receiptModalSheetBloc,
      _transactionRepository = transactionRepository,
      _transactionIssueRepository = transactionIssueRepository,
      _openTransactionsBloc = openTransactionsBloc,
      _showAppBar = showAppBar,
      super(key: key);

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
      child: ReceiptScreenBody(
        showAppBar: widget._showAppBar,
        transactionRepository: widget._transactionRepository,
        transactionIssueRepository: widget._transactionIssueRepository,
        openTransactionsBloc: widget._openTransactionsBloc,
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget._receiptModalSheetBloc.add(Toggle());
  }
}