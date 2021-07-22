import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/reset_password_args.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/routing/routes.dart';
import 'package:heist/screens/request_reset_password_screen/bloc/request_reset_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class RequestResetPasswordForm extends StatefulWidget {

  @override
  State<RequestResetPasswordForm> createState() => _RequestResetPasswordFormState();
}

class _RequestResetPasswordFormState extends State<RequestResetPasswordForm> {
  final FocusNode _emailFocusNode = FocusNode();
  late TextEditingController _emailController;

  late RequestResetFormBloc _formBloc;

  @override
  void initState() {
    super.initState();
    _formBloc = BlocProvider.of<RequestResetFormBloc>(context);
    _emailController = TextEditingController();
    _emailController.addListener(_onEmailChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<RequestResetFormBloc, RequestResetFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackbar();
          Navigator.of(context).pushReplacementNamed(Routes.resetPassword, arguments: ResetPasswordArgs(email: _emailController.text));
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(error: state.errorMessage);
          _formBloc.add(Reset());
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: KeyboardActions(
                  config: _buildKeyboard(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      VeryBoldText2(text: 'Verify Your Email', context: context),
                      _emailTextField(),
                      SizedBox(height: SizeConfig.getHeight(10)),
                    ],
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    SizedBox(width: SizeConfig.getWidth(10)),
                    Expanded(child: _submitButton()),
                    SizedBox(width: SizeConfig.getWidth(10)),
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
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  Widget _emailTextField() {
    return BlocBuilder<RequestResetFormBloc, RequestResetFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("emailFormFieldKey"),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6),
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _emailFocusNode,
          validator: (_) => !state.isEmailValid
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
          key: Key("submitButtonKey"),
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
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Submit', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  bool _buttonEnabled({required RequestResetFormState state}) {
    return state.isEmailValid && _emailController.text.isNotEmpty && !state.isSubmitting;
  }

  void _submitButtonPressed({required RequestResetFormState state}) {
    if (_buttonEnabled(state: state)) {
      _formBloc.add(Submitted(email: _emailController.text));
    }
  }

  void _showSnackbar({String? error}) async {
    error == null ? Vibrate.success() : Vibrate.error();

    final String text = error == null
      ? 'Reset PIN code sent. Please check your email.'
      : error;

    final SnackBar snackBar = SnackBar(
      key: Key("requestResetSnackBarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText4(text: text, context: context, color: Theme.of(context).colorScheme.onSecondary)
          ),
        ],
      ),
      backgroundColor: error == null
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  void _onEmailChanged() {
    _formBloc.add(EmailChanged(email: _emailController.text));
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
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
                ),
              );
            }
          ]
        ),
      ]
    );
  }
}