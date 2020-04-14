import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/screens/historic_transactions_screen/widget/historic_transactions_list.dart';

import 'bloc/historic_transactions_bloc.dart';

class HistoricTransactionsScreen extends StatelessWidget {
  final TransactionRepository _transactionRepository = TransactionRepository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: Padding(
        padding: EdgeInsets.only(left: 8, right: 8),
        child: BlocProvider<HistoricTransactionsBloc>(
          create: (BuildContext context) => HistoricTransactionsBloc(transactionRepository: _transactionRepository)
            ..add(FetchHistoricTransactions()),
          child: HistoricTransactionsList(),
        ),
      ),
    );
  }
  
}