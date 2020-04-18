import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/repositories/transaction_repository.dart';

import 'bloc/historic_transactions_bloc.dart';
import 'widgets/historic_transactions_body.dart';

class HistoricTransactionsScreen extends StatelessWidget {
  final TransactionRepository _transactionRepository = TransactionRepository();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: BlocProvider<HistoricTransactionsBloc>(
        create: (BuildContext context) => HistoricTransactionsBloc(transactionRepository: _transactionRepository)
          ..add(FetchHistoricTransactions()),
        child: HistoricTransactionsBody(),
      ) 
    );
  }
}