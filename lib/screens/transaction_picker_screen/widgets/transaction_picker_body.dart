import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/receipt_modal_sheet/receipt_modal_sheet_bloc.dart';
import 'package:heist/resources/helpers/loading_widget.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/receipt_screen.dart';
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
            return ReceiptScreen(transactionResource: state.transaction, receiptModalSheetBloc: BlocProvider.of<ReceiptModalSheetBloc>(context), showAppBar: false,);
          }
          return BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc()
              ..add(PickerChanged(transactionResource: state.transactions[0])),
            child: Transaction(transactions: state.transactions),
          );
        } else if (state is Loading || state is Uninitialized) {
          return Center(
            child: LoadingWidget(),
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