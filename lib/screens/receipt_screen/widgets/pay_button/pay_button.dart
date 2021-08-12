import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/receipt_screen/widgets/pay_button/bloc/pay_button_bloc.dart';
import 'package:heist/themes/global_colors.dart';

class PayButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  PayButton({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PayButtonBloc, PayButtonState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context, state.errorMessage, state);
        } else if (state.isSubmitSuccess) {
          _showSnackbar(context, "Success! Payment pending.", state);
        }
      },
      child: BlocBuilder<PayButtonBloc, PayButtonState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.isEnabled 
              ? () => BlocProvider.of<PayButtonBloc>(context).add(Submitted(transactionId: _transactionResource.transaction.identifier))
              : null,
            child: _buttonChild(context: context, state: state),
          );
        }
      )
    );
  }

  Widget _buttonChild({required BuildContext context, required PayButtonState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Pay', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _showSnackbar(BuildContext context, String message, PayButtonState state) async {
    state.isSubmitSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
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
          BlocProvider.of<PayButtonBloc>(context).add(Reset(transactionResource: _transactionResource))
        }
      }
    );
  }
}