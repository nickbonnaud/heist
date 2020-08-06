import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/blocs/open_transactions/open_transactions_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/receipt_screen/bloc/receipt_screen_bloc.dart';
import 'package:heist/screens/receipt_screen/widgets/pay_button/bloc/pay_button_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:vibrate/vibrate.dart';

class PayButton extends StatelessWidget {
  final TransactionResource _transactionResource;

  PayButton({@required TransactionResource transactionResource})
    : assert(transactionResource != null),
      _transactionResource = transactionResource;
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PayButtonBloc, PayButtonState>(
      listener: (context, state) {
        if (state.isSubmitFailure) {
          _showSnackbar(context, "Failed to pay for transaction. Please try again.", state);
        } else if (state.isSubmitSuccess) {
          _showSnackbar(context, "Success! Payment pending.", state);
        }
      },
      child: BlocBuilder<PayButtonBloc, PayButtonState>(
        builder: (context, state) {
          return RaisedButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            onPressed: state.isEnabled 
              ? () => BlocProvider.of<PayButtonBloc>(context).add(Submitted(transactionId: _transactionResource.transaction.identifier))
              : null,
            child: _createButtonText(context: context, state: state),
          );
        }
      )
    );
  }

  Widget _createButtonText({@required BuildContext context, @required PayButtonState state}) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Paying...'],
        textStyle: TextStyle(
          fontSize: SizeConfig.getWidth(6),
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.onSecondary
        ),
      );
    } else {
      return BoldText3(text: 'Pay', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _showSnackbar(BuildContext context, String message, PayButtonState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSubmitSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSubmitSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSubmitSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Theme.of(context).colorScheme.onError,
                ),
              )
            ],
          ),
          backgroundColor: state.isSubmitSuccess 
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error
        )
      ).closed.then((_) => {
        if (state.isSubmitSuccess) {
          BlocProvider.of<ReceiptScreenBloc>(context).add(TransactionChanged(transactionResource: state.transactionResource)),
          BlocProvider.of<OpenTransactionsBloc>(context).add(RemoveOpenTransaction(transaction: state.transactionResource))
        } else {
          BlocProvider.of<PayButtonBloc>(context).add(Reset())
        }
      });
  }
}