import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/global_widgets/error_screen/error_screen.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/transaction_picker_screen/bloc/transaction_picker_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'transaction/bloc/transaction_bloc.dart';
import 'transaction/transaction.dart';


class TransactionPickerBody extends StatelessWidget {
  final String _businessIdentifier;
  final bool _fromSettings;

  const TransactionPickerBody({required String businessIdentifier, required bool fromSettings})
    : _businessIdentifier = businessIdentifier,
      _fromSettings = fromSettings;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionPickerScreenBloc, TransactionPickerScreenState>(
      listener: (context, state) {
        if (state.claimSuccess) {
          _fromSettings 
            ? Navigator.of(context).pushNamedAndRemoveUntil(Routes.receipt, ModalRoute.withName(Routes.home), arguments: state.transaction)
            : Navigator.of(context).pushReplacementNamed(Routes.receipt, arguments: state.transaction);
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, message: state.errorMessage, state: state);
        }
      },
      child: BlocBuilder<TransactionPickerScreenBloc, TransactionPickerScreenState>(
        builder: (context, state) {
          if (state.loading) return Center(child: CircularProgressIndicator());
          if (state.errorMessage.isNotEmpty) {
            return ErrorScreen(
              body: "Oops! An error occurred fetching Unclaimed Transactions!\n\n Please try again.",
              buttonText: "Retry",
              onButtonPressed: () => BlocProvider.of<TransactionPickerScreenBloc>(context).add(Fetch(businessIdentifier: _businessIdentifier)),
            );
          }

          return BlocProvider<TransactionBloc>(
            create: (BuildContext context) => TransactionBloc()
              ..add(PickerChanged(transactionUpdatedAt: state.transactions[0].transaction.updatedDate)),
            child: Transaction(transactions: state.transactions),
          ); 
        }
      ),
    );
  }

  void _showSnackbar({required BuildContext context, required String message, required TransactionPickerScreenState state}) async {
    state.claimSuccess ? Vibrate.success() : Vibrate.error();
    
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
          ),
        ],
      ),
      backgroundColor: state.claimSuccess 
        ? Theme.of(context).colorScheme.iconPrimary
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.errorMessage.isNotEmpty) {
          BlocProvider.of<TransactionPickerScreenBloc>(context).add(Reset())
        }
      }
    );
  }
}