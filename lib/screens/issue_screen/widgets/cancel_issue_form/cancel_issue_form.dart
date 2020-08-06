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
import 'package:heist/themes/global_colors.dart';

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
                BoldTextCustom(text: "Cancel Issue?", context: context, size: SizeConfig.getWidth(9)),
                SizedBox(height: SizeConfig.getHeight(15)),
                BoldText2(text: "${_transactionResource.issue.message} is no longer a problem?", context: context, color: Theme.of(context).colorScheme.onPrimarySubdued)
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
                    builder: (context, state) {
                      return OutlineButton(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.callToAction
                        ),
                        disabledBorderColor: Theme.of(context).colorScheme.callToActionDisabled,
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                        child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting
                          ? Theme.of(context).colorScheme.callToActionDisabled
                          : Theme.of(context).colorScheme.callToAction
                        ),
                      );
                    }
                  )
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
                    builder: (context, state) {
                      return RaisedButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        onPressed: !state.isSubmitting ? () => _submitButtonPressed(context, state) : null,
                        child: _createButtonText(context: context, state: state),
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

  Widget _createButtonText({@required BuildContext context, @required CancelIssueFormState state}) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: ['Cancelling...'],
        textStyle: GoogleFonts.roboto(
          textStyle: TextStyle(
            fontSize: SizeConfig.getWidth(6),
            fontWeight: FontWeight.w700
          ),
          color: Theme.of(context).colorScheme.onSecondary
        ),
      );
    } else {
      return BoldText3(text: 'Cancel', context: context, color: Theme.of(context).colorScheme.onSecondary);
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
                child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
              ),
              PlatformWidget(
                android: (_) => Icon(state.isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    state.isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              )
            ],
          ),
          backgroundColor: state.isSuccess
          ? Theme.of(context).colorScheme.success
          : Theme.of(context).colorScheme.error,
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