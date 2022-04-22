import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/historic_transactions_bloc.dart';
import 'widgets/historic_transactions_body.dart';

class HistoricTransactionsScreen extends StatelessWidget {

  const HistoricTransactionsScreen({Key? key})
    : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (_) => DefaultAppBarBloc(),
      child: BlocProvider<HistoricTransactionsBloc>(
        create: (BuildContext context) => HistoricTransactionsBloc(
          transactionRepository: RepositoryProvider.of<TransactionRepository>(context)
        )..add(const FetchHistoricTransactions()),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          body: const HistoricTransactionsBody(),
        ),
      ) 
    );
  }
}