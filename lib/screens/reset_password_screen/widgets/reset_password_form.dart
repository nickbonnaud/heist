import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/reset_password_screen/bloc/reset_password_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class ResetPasswordForm extends StatefulWidget {

  @override
  State<ResetPasswordForm> createState() => _ResetPasswordFormState();
}

class _ResetPasswordFormState extends State<ResetPasswordForm> {
  final FocusNode _resetCodeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();

  final TextEditingController _resetCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();

  late ResetPasswordFormBloc _resetPasswordFormBloc;
  
  bool get fieldsNotEmpty => _resetCodeController.text.isNotEmpty && _passwordController.text.isNotEmpty && _passwordConfirmationController.text.isNotEmpty;
  
  @override
  void initState() {
    super.initState();
    _resetPasswordFormBloc = BlocProvider.of<ResetPasswordFormBloc>(context);

    _resetCodeController.addListener(_onResetCodeChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordFormBloc, ResetPasswordFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackbar();
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(error: state.errorMessage);
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
                      VeryBoldText2(text: 'Reset Your Password', context: context),
                      _resetCodeField(),
                      SizedBox(height: SizeConfig.getHeight(2)),
                      _passwordField(),
                      SizedBox(height: SizeConfig.getHeight(2)),
                      _passwordConfirmationField(),
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
    _resetCodeFocusNode.dispose();
    _passwordFocusNode.dispose();
    _passwordConfirmationFocusNode.dispose();

    _resetCodeController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Widget _resetCodeField() {
    return BlocBuilder<ResetPasswordFormBloc, ResetPasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("resetCodeFormKey"),
          decoration: InputDecoration(
            labelText: 'Reset Code',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6),
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _resetCodeController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          focusNode: _resetCodeFocusNode,
          validator: (_) => !state.isResetCodeValid
            ? "Invalid Reset Code"
            : null,
        );
      }
    );
  }

  Widget _passwordField() {
    return BlocBuilder<ResetPasswordFormBloc, ResetPasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("passwordFormKey"),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6),
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _passwordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          focusNode: _passwordFocusNode,
          validator: (_) => !state.isPasswordValid
            ? 'Min 8 characters, at least 1 uppercase, 1 number, 1 special character'
            : null,
        );
      }
    );
  }

  Widget _passwordConfirmationField() {
    return BlocBuilder<ResetPasswordFormBloc, ResetPasswordFormState>(
      builder: (context, state) {
        return TextFormField(
          key: Key("passwordConfirmationKey"),
          decoration: InputDecoration(
            labelText: 'Password Confirmation',
            labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: SizeConfig.getWidth(6),
            ),
          ),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: SizeConfig.getWidth(7)
          ),
          controller: _passwordConfirmationController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          focusNode: _passwordConfirmationFocusNode,
          validator: (_) => !state.isPasswordConfirmationValid
            ? "Passwords do not match"
            : null,
        );
      }
    );
  }

  Widget _submitButton() {
    return BlocBuilder<ResetPasswordFormBloc, ResetPasswordFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          onPressed: _buttonEnabled(state: state)
            ? () => _submitButtonPressed(state: state)
            : null,
          child: _buttonChild(state: state)
        );
      },
    );
  }

  Widget _buttonChild({required ResetPasswordFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      return BoldText3(text: 'Submit', context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  bool _buttonEnabled({required ResetPasswordFormState state}) {
    return state.fieldsValid && fieldsNotEmpty && !state.isSubmitting;
  }

  void _submitButtonPressed({required ResetPasswordFormState state}) {
    if (_buttonEnabled(state: state)) {
      _resetPasswordFormBloc.add(Submitted(
        resetCode: _resetCodeController.text,
        password: _passwordController.text,
        passwordConfirmation: _passwordConfirmationController.text
      ));
    }
  }
  
  void _onResetCodeChanged() {
    _resetPasswordFormBloc.add(ResetCodeChanged(resetCode: _resetCodeController.text));
  }

  void _onPasswordChanged() {
    _resetPasswordFormBloc.add(PasswordChanged(password: _passwordController.text, passwordConfirmation: _passwordConfirmationController.text));
  }

  void _onPasswordConfirmationChanged() {
    _resetPasswordFormBloc.add(PasswordConfirmationChanged(passwordConfirmation: _passwordConfirmationController.text, password: _passwordController.text));
  }

  void _showSnackbar({String? error}) async {
    error == null ? Vibrate.success() : Vibrate.error();

    final String text = error == null
      ? "Password Reset. Please Login."
      : error;

    final SnackBar snackBar = SnackBar(
      key: Key("resetSnackBarKey"),
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
      ..showSnackBar(snackBar)
      .closed.then((_) {
        if (error == null) {
          Navigator.of(context).pop();
        } else {
          _resetPasswordFormBloc.add(Reset());
        }
      });
  }

  KeyboardActionsConfig _buildKeyboard() {
    return KeyboardActionsConfig(
      keyboardBarColor: Theme.of(context).colorScheme.keyboardHelpBarDark,
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        KeyboardActionsItem(
          focusNode: _resetCodeFocusNode,
          toolbarButtons: [
            (node) => GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
              ),
            )
          ]
        ),
        KeyboardActionsItem(
          focusNode: _passwordFocusNode,
          toolbarButtons: [
            (node) => GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
              ),
            )
          ]
        ),
        KeyboardActionsItem(
          focusNode: _passwordConfirmationFocusNode,
          toolbarButtons: [
            (node) => GestureDetector(
              onTap: () => node.unfocus(),
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: BoldText5(text: 'Done', context: context, color: Theme.of(context).colorScheme.primary),
              ),
            )
          ]
        )
      ]
    );
  }
}