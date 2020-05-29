import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/issue_screen/widgets/cancel_issue_form/bloc/cancel_issue_form_bloc.dart';
import 'package:vibrate/vibrate.dart';

class CancelIssueForm extends StatelessWidget {
  final TransactionResource _transactionResource;

  CancelIssueForm({@required TransactionResource transactionResource})
    : assert(transactionResource != null),
      _transactionResource = transactionResource;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelIssueFormBloc, CancelIssueFormState>(
      listener: (context, state) {
        if (state.isFailure) {
          _showSnackbar(context, 'Failed to cancel issue!', state);
        } else if (state.isSuccess) {
          _showSnackbar(context, 'Issue canceled!', state);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: SizeConfig.getHeight(3)),
                BoldText(text: "Cancel Issue?", size: SizeConfig.getWidth(9), color: Colors.black),
                SizedBox(height: SizeConfig.getHeight(15)),
                BoldText(text: "${_transactionResource.issue.message} is no longer a problem?", size: SizeConfig.getWidth(7), color: Colors.black54)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
                    builder: (context, state) {
                      return OutlineButton(
                        borderSide: BorderSide(
                          color: Colors.black
                        ),
                        disabledBorderColor: Colors.grey.shade500,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                        child: BoldText(text: 'Cancel', size: SizeConfig.getWidth(6), color: state.isSubmitting ? Colors.grey.shade500 : Colors.black),
                      );
                    }
                  )
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
                    builder: (context, state) {
                      return RaisedButton(
                        color: Colors.green,
                        disabledColor: Colors.green.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        onPressed: !state.isSubmitting ? () => _submitButtonPressed(context, state) : null,
                        child: _createButtonText(state),
                      );
                    }
                  ) 
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submitButtonPressed(BuildContext context, CancelIssueFormState state) {
    if (!state.isSubmitting) {
      BlocProvider.of<CancelIssueFormBloc>(context).add(Submitted(
        issueIdentifier: _transactionResource.issue.identifier
      ));
    }
  }

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _createButtonText(CancelIssueFormState state) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Cancelling...'],
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: SizeConfig.getWidth(6),
            fontWeight: FontWeight.w700
          ),
          color: Colors.white
        ),
      );
    } else {
      return BoldText(text: 'Cancel', size: SizeConfig.getWidth(6), color: Colors.white);
    }
  }

  void _showSnackbar(BuildContext context, String message, CancelIssueFormState state) async {
    bool canVibrate = await Vibrate.canVibrate;
    if (canVibrate) {
      Vibrate.feedback(state.isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText(text: message, size: SizeConfig.getWidth(6), color: Colors.white)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Colors.white,
                ),
              )
            ],
          ),
          backgroundColor: state.isSuccess ? Colors.green : Colors.red,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop(state.transactionResource)
        } else {
          BlocProvider.of<CancelIssueFormBloc>(context).add(Reset())
        }
      });
  }
}