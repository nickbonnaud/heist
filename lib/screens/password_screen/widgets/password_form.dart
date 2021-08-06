import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/password_screen/bloc/password_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PasswordForm extends StatefulWidget {
  final Customer _customer;

  PasswordForm({required Customer customer})
    : _customer = customer;

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController = TextEditingController();
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();


  late PasswordFormBloc _passwordFormBloc;

  @override
  void initState() {
    super.initState();
    _passwordFormBloc = BlocProvider.of<PasswordFormBloc>(context);
    _oldPasswordController.addListener(_onOldPasswordChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }
  
  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordFormBloc, PasswordFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          _showSnackbar(message: 'Password updated!', state: state);
        } else if (state.isSuccessOldPassword) {
          _showSnackbar(message: 'Password verified.', state: state);
        } else if (state.errorMessage.isNotEmpty) {
          _showSnackbar(message: state.errorMessage, state: state);
        }
      },
      child: Form(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BlocBuilder<PasswordFormBloc, PasswordFormState>(
                  builder: (context, state) {
                    return KeyboardActions(
                      config: _buildKeyboard(state: state),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          VeryBoldText1(text: 'Change Password', context: context),
                          _currentPassword(state: state),
                          _newPassword(state: state),
                          _newPasswordConfirmation(state: state),
                          SizedBox(height: SizeConfig.getHeight(10)),
                        ],
                      ),
                    );
                  },
                ) 
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: _submitButton()
                    )
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
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();

    _oldPasswordFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  Widget _currentPassword({required PasswordFormState state}) {
    return TextFormField(
      key: Key("currentPasswordFieldKey"),
      decoration: InputDecoration(
        labelText: 'Current Password',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.getWidth(6)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: SizeConfig.getWidth(7)
      ),
      controller: _oldPasswordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => !state.isOldPasswordValid && _oldPasswordController.text.isNotEmpty
        ? 'Invalid Password'
        : null,
      obscureText: true,
      focusNode: _oldPasswordFocus,
      onFieldSubmitted: (_) {
        _submit(state: state);
      },
      enabled: !state.isOldPasswordVerified,
    );
  }

  Widget _newPassword({required PasswordFormState state}) {
    return TextFormField(
      key: Key("newPasswordFieldKey"),
      decoration: InputDecoration(
        labelText: 'New Password',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.getWidth(6)
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: SizeConfig.getWidth(7)
      ),
      controller: _passwordController,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty
        ? 'Invalid Password'
        : null,
      obscureText: true,
      focusNode: _passwordFocus,
      onFieldSubmitted: (_) {
        _passwordFocus.unfocus();
        FocusScope.of(context).requestFocus(_passwordConfirmationFocus);
      },
      enabled: state.isOldPasswordVerified,
    );
  }

  Widget _newPasswordConfirmation({required PasswordFormState state}) {
    return TextFormField(
      key: Key("newPasswordConfirmationFieldKey"),
      decoration: InputDecoration(
        labelText: 'Password Confirmation',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: SizeConfig.getWidth(6)
        )
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
      validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty
        ? 'Confirmation does not match'
        : null,
      obscureText: true,
      focusNode: _passwordConfirmationFocus,
      onFieldSubmitted: (_) {
        _passwordFocus.unfocus();
      },
      enabled: state.isOldPasswordVerified,
    );
  }

  Widget _cancelButton() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        return OutlinedButton(
          key: Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting 
            ? Theme.of(context).colorScheme.callToActionDisabled
            : Theme.of(context).colorScheme.callToAction
          ),
        );
      },
    );
  }

  Widget _submitButton() {
    return BlocBuilder<PasswordFormBloc, PasswordFormState>(
      builder: (context, state) {
        return ElevatedButton(
          key: Key("submitButtonKey"),
          onPressed: _canSubmit(state: state) ? () => _submit(state: state) : null,
          child: _buttonChild(state: state),
        );
      },
    );
  }

  bool _canSubmit({required PasswordFormState state}) {
    if (state.isOldPasswordVerified) {
      return state.isPasswordValid && _passwordController.text.isNotEmpty && state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty && !state.isSubmitting;
    } else {
      return state.isOldPasswordValid && _oldPasswordController.text.isNotEmpty && !state.isSubmitting;
    }
  }

  void _submit({required PasswordFormState state}) {
    if (_canSubmit(state: state)) {
      state.isOldPasswordVerified 
        ? _passwordFormBloc.add(NewPasswordSubmitted(
            oldPassword: _oldPasswordController.text,
            password: _passwordController.text,
            passwordConfirmation: _passwordConfirmationController.text,
            customerIdentifier: widget._customer.identifier
          ))
        : _passwordFormBloc.add(OldPasswordSubmitted(oldPassword: _oldPasswordController.text));
    }
  }
  
  void _onOldPasswordChanged() {
    _passwordFormBloc.add(OldPasswordChanged(oldPassword: _oldPasswordController.text));
  }

  void _onPasswordChanged() {
    _passwordFormBloc.add(PasswordChanged(password: _passwordController.text, passwordConfirmation: _passwordConfirmationController.text));
  }

  void _onPasswordConfirmationChanged() {
    _passwordFormBloc.add(PasswordConfirmationChanged(passwordConfirmation: _passwordConfirmationController.text, password: _passwordController.text));
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  void _showSnackbar({required String message, required PasswordFormState state}) async  {
    bool isSuccess = state.isSuccess || state.isSuccessOldPassword;
    isSuccess ? Vibrate.success() : Vibrate.error();

    final SnackBar snackBar = SnackBar(
      key: Key("passwordFormSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.onSecondary)
          ),
        ],
      ),
      backgroundColor: isSuccess 
        ? Theme.of(context).colorScheme.success
        : Theme.of(context).colorScheme.error,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar)
      .closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<PasswordFormBloc>(context).add(Reset())
        }
      }
    );
  }

  Widget _buttonChild({required PasswordFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: SizeConfig.getWidth(5), width: SizeConfig.getWidth(5), child: CircularProgressIndicator());
    } else {
      String text = state.isOldPasswordVerified ? 'Save' : 'Verify';
      return BoldText3(text: text, context: context, color: Theme.of(context).colorScheme.onSecondary);
    }
  }

  KeyboardActionsConfig _buildKeyboard({required PasswordFormState state}) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        if (!state.isOldPasswordVerified) 
          KeyboardActionsItem(
            displayArrows: false,
            focusNode: _oldPasswordFocus,
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
        KeyboardActionsItem(
          focusNode: _passwordFocus,
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
        KeyboardActionsItem(
          focusNode: _passwordConfirmationFocus,
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