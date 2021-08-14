import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';

import 'transaction/bloc/transaction_bloc.dart';
import 'transaction/transaction.dart';


class TransactionPickerBody extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      builder: (context, state) {
        if (state is TransactionsLoaded) {
          if (state.claimSuccess) {
            Navigator.of(context).pushReplacementNamed(Routes.receipt, arguments: state.transaction);
          }
          return BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc()
              ..add(PickerChanged(transactionUpdatedAt: state.transactions[0].transaction.updatedDate)),
            child: Transaction(transactions: state.transactions),
          );
        } else if (state is Loading || state is Uninitialized) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Center(
            child: BoldText4(text: 'Failed to Fetch Posts', context: context),
          );
        }
      }
    );
  }
}