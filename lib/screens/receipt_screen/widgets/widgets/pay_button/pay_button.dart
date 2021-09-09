import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/themes/global_colors.dart';

import 'bloc/pay_button_bloc.dart';

class PayButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  PayButton({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PayButtonBloc, PayButtonState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, message: state.errorMessage, state: state);
        } else if (state.isSubmitSuccess) {
          _showSnackbar(context: context, message: "Success! Payment pending.", state: state);
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
      return SizedBox(height: 25.sp, width: 25.sp, child: CircularProgressIndicator());
    } else {
      return Text(
        'Pay',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 22.sp
        ),
      );
    }
  }

  void _showSnackbar({required BuildContext context, required String message, required PayButtonState state}) async {
    state.isSubmitSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
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