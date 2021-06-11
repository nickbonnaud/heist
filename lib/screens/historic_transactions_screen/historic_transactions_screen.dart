import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/default_app_bar/bloc/default_app_bar_bloc.dart';
import 'package:heist/repositories/business_repository.dart';
import 'package:heist/repositories/transaction_repository.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/historic_transactions_bloc.dart';
import 'widgets/historic_transactions_body.dart';

class HistoricTransactionsScreen extends StatelessWidget {
  final TransactionRepository _transactionRepository;
  final BusinessRepository _businessRepository;

  HistoricTransactionsScreen({required TransactionRepository transactionRepository, required BusinessRepository businessRepository})
    : _transactionRepository = transactionRepository,
      _businessRepository = businessRepository;
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DefaultAppBarBloc>(
      create: (BuildContext context) => DefaultAppBarBloc(),
      child: BlocProvider<HistoricTransactionsBloc>(
        create: (BuildContext context) => HistoricTransactionsBloc(transactionRepository: _transactionRepository)
          ..add(FetchHistoricTransactions()),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.scrollBackground,
          body: HistoricTransactionsBody(businessRepository: _businessRepository,),
        ),
      ) 
    );
  }
}