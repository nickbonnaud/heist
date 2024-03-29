import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/reset_password_args.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/screens/request_reset_password_screen/bloc/request_reset_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class RequestResetPasswordForm extends StatefulWidget {

  const RequestResetPasswordForm({Key? key})
    : super(key: key);
  
  @override
  State<RequestResetPasswordForm> createState() => _RequestResetPasswordFormState();
}

class _RequestResetPasswordFormState extends State<RequestResetPasswordForm> {
  final FocusNode _emailFocusNode = FocusNode();

  late RequestResetFormBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = BlocProvider.of<RequestResetFormBloc>(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestResetFormBloc, RequestResetFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackbar();
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(error: state.errorMessage);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const ScreenTitle(title: 'Verify Email'),
                      _emailTextField(),
                      SizedBox(height: 65.h),
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Row(
                  children: [
                    SizedBox(width: .1.sw),
                    Expanded(child: _submitButton()),
                    SizedBox(width: .1.sw),
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<RequestResetFormBloc, RequestResetFormState>(
      builder: (context, state) {
        return TextFormField(
          key: const Key("emailFormFieldKey"),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 25.sp,
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 28.sp
          ),
          onChanged: (email) => _onEmailChanged(email: email),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _emailFocusNode,
          validator: (_) => !state.isEmailValid && state.email.isNotEmpty
            ? "Invalid Email"
            : null,
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<RequestResetFormBloc, RequestResetFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: const Key("submitButtonKey"),
          onPressed: _buttonEnabled(state: state)
            ? () => _submitButtonPressed(state: state)
            : null,
          child: _buttonChild(state: state)
        );
      }
    );
  }

  Widget _buttonChild({required RequestResetFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    } else {
      return const ButtonText(text: 'Submit');
    }
  }

  bool _buttonEnabled({required RequestResetFormState state}) {
    return state.isFormValid && !state.isSubmitting;
  }

  void _submitButtonPressed({required RequestResetFormState state}) {
    if (_buttonEnabled(state: state)) {
      _formBloc.add(Submitted());
    }
  }

  void _showSnackbar({String? error}) async {
    error == null ? Vibrate.success() : Vibrate.error();
    final String text = error ?? 'Reset PIN code sent. Please check your email.';

    final SnackBar snackBar = SnackBar(
      key: const Key("requestResetSnackBarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: text)
          ),
        ],
      ),
      backgroundColor: error == null
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) {
        _formBloc.add(Reset());
        if (error == null) {
          Navigator.of(context).pushReplacementNamed(Routes.resetPassword, arguments: ResetPasswordArgs(email: _formBloc.state.email));
        }
      });
  }

  void _onEmailChanged({required String email}) {
    _formBloc.add(EmailChanged(email: email));
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.keyboardHelpBarDark,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _emailFocusNode,
          toolbarButtons: [
            (node) {
              return TextButton(
                onPressed: () => node.unfocus(), 
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: const ActionText()
                )
              );
            }
          ]
        ),
      ]
    );
  }
}