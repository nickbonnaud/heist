import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/constants.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:heist/screens/sign_out_screen/bloc/sign_out_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ScreenTitle(title: "Log Out?", color: Theme.of(context).colorScheme.danger),
                  Column(
                    children: [
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25.sp
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "${Constants.appName} does not work if you are not logged in!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              )
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Expanded(child: _cancelButton(context: context)),
                  SizedBox(width: 20.w),
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
          child: ButtonText(text: 'Cancel', color: state.isSubmitting
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
      return SizedBox(height: 25.w, width: 25.w, child: CircularProgressIndicator(color: Theme.of(context).colorScheme.onDanger));
    } else {
      return ButtonText(text: 'Logout');
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
        children: [
          Expanded(
            child: SnackbarText(text: error)
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