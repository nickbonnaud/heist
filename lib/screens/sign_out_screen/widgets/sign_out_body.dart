import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:heist/screens/sign_out_screen/bloc/sign_out_bloc.dart';

class SignOutBody extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignOutBloc, SignOutState>(
      listener: (context, state) {
        if (state.errorMessage.isNotEmpty) {
          _showSnackbar(context: context, error: state.errorMessage);
        }
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  VeryBoldText1(text: "Log Out?", context: context, color: Theme.of(context).colorScheme.danger),
                  Column(
                    children: [
                      BoldText3(text: "Are you sure?", context: context),
                      SizedBox(height: SizeConfig.getHeight(1)),
                      BoldText3(text: "${Constants.appName} does not work if you are not logged in!", context: context),
                    ],
                  ),
                  SizedBox(height: SizeConfig.getHeight(10)),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(child: _cancelButton(context: context)),
                  SizedBox(width: 20),
                  Expanded(child: _submitButton(context: context))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _cancelButton({required BuildContext context}) {
    return BlocBuilder<SignOutBloc, SignOutState>(
      builder: (context, state) {
        return OutlinedButton(
          key: Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context: context),
          child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          ),
        );
      }
    );
  }

  Widget _submitButton({required BuildContext context}) {
    return BlocBuilder<SignOutBloc, SignOutState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          style: TextButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.danger),
          onPressed: state.isSubmitting
            ? null
            : () => _submitButtonPressed(context: context, state: state),
          child: _buttonChild(context: context, state: state),
        );
      }
    );
  }

  Widget _buttonChild({required BuildContext context, required SignOutState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onDanger));
    } else {
      return BoldText3(text: 'Logout', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  void _cancelButtonPressed({required BuildContext context}) {
    Navigator.pop(context);
  }

  void _submitButtonPressed({required BuildContext context, required SignOutState state}) {
    if (!state.isSubmitting) {
      BlocProvider.of<SignOutBloc>(context).add(Submitted());
    }
  }
  
  void _showSnackbar({required BuildContext context, required String error}) async {
    Vibrate.error();
    
    final SnackBar snackBar = SnackBar(
      key: Key("signOutSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(text: error, context: context, color: Theme.of(context).colorScheme.onSecondary)
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => BlocProvider.of<SignOutBloc>(context).add(Reset()));
  }
}