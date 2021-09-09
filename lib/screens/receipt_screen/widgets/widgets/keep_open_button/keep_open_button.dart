import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
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
      return SizedBox(height: 25.sp, width: 25.sp, child: CircularProgressIndicator());
    } else {
      return Text(
        'Keep Open',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
          fontSize: 22.sp
        ),
      );
    }
  }


  void _showSnackbar({required BuildContext context, required String message, required KeepOpenButtonState state}) async {
    state.isSubmitSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
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
          BlocProvider.of<KeepOpenButtonBloc>(context).add(Reset())
        }
      }
    );
  }
}