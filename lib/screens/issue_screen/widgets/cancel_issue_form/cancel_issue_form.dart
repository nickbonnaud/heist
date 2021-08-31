import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/transaction/transaction_resource.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/issue_screen/widgets/cancel_issue_form/bloc/cancel_issue_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelIssueForm extends StatelessWidget {
  final TransactionResource _transactionResource;

  CancelIssueForm({required TransactionResource transactionResource})
    : _transactionResource = transactionResource;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelIssueFormBloc, CancelIssueFormState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, message: state.errorMessage, state: state);
        } else if (state.isSuccess) {
          _showSnackbar(context: context, message: 'Issue canceled!', state: state);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(height: 25.h),
                ScreenTitle(title: "Cancel Issue?"),
                SizedBox(height: 120.h),
                Text(
                  "${_transactionResource.issue!.message} is no longer a problem?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimarySubdued,
                    fontSize: 28.sp
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _cancelButton()
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: _submitButton()
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
      builder: (context, state) {
        return OutlinedButton(
          key: Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context: context),
          child: ButtonText(text: 'Cancel', color: state.isSubmitting
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          ),
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<CancelIssueFormBloc, CancelIssueFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          onPressed: !state.isSubmitting ? () => _submitButtonPressed(context: context, state: state) : null,
          child: _buttonChild(context: context, state: state),
        );
      }
    );
  }

  Widget _buttonChild({required BuildContext context, required CancelIssueFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.w, width: 25.w, child: CircularProgressIndicator());
    } else {
      return ButtonText(text: 'Submit');
    }
  }

  void _submitButtonPressed({required BuildContext context, required CancelIssueFormState state}) {
    if (!state.isSubmitting) {
      BlocProvider.of<CancelIssueFormBloc>(context).add(Submitted(
        issueIdentifier: _transactionResource.issue!.identifier
      ));
    }
  }

  void _cancelButtonPressed({required BuildContext context}) {
    Navigator.pop(context);
  }

  void _showSnackbar({required BuildContext context, required String message, required CancelIssueFormState state}) async {
    state.isSuccess ? Vibrate.success() : Vibrate.error();
    final SnackBar snackBar = SnackBar(
      key: Key("cancelIssueSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
          ),
        ],
      ),
      backgroundColor: state.isSuccess
      ? Theme.of(context).colorScheme.success
      : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop(state.transactionResource)
        } else {
          BlocProvider.of<CancelIssueFormBloc>(context).add(Reset())
        }
      }
    );
  }
}