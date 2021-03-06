import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/keep_open_button_bloc.dart';

class KeepOpenButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  KeepOpenButton({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;

  @override
  Widget build(BuildContext context) {
    return BlocListener<KeepOpenButtonBloc, KeepOpenButtonState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, message: state.errorMessage, state: state);
        } else if (state.isSubmitSuccess) {
          _showSnackbar(context: context, message: "Success! Bill will be kept open for 10 minutes. Please return to ${_transactionResource.business.profile.name} before then.", state: state);
        }
      },
      child: BlocBuilder<KeepOpenButtonBloc, KeepOpenButtonState>(
        builder: (context, state) {
          return ElevatedButton(
            style: ElevatedButtonTheme.of(context).style!.copyWith(
              backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.disabled)) {
                  return Theme.of(context).colorScheme.infoDisabled;
                }
                return Theme.of(context).colorScheme.info;
              })
            ),
            onPressed: () => BlocProvider.of<KeepOpenButtonBloc>(context).add(Submitted(transactionId: _transactionResource.transaction.identifier)),
            child: _buttonChild(context: context, state: state),
          );
        }
      ),
    );
  }

  Widget _buttonChild({required BuildContext context, required KeepOpenButtonState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Keep Open', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }


  void _showSnackbar({required BuildContext context, required String message, required KeepOpenButtonState state}) async {
    state.isSubmitSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
          ),
        ],
      ),
      backgroundColor: state.isSubmitSuccess 
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (!state.isSubmitSuccess) {
          BlocProvider.of<KeepOpenButtonBloc>(context).add(Reset())
        }
      }
    );
  }
}