import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heist/resources/helpers/global_text.dart';
import 'package:heist/resources/helpers/vibrate.dart';
import 'package:heist/screens/password_screen/bloc/password_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class PasswordForm extends StatefulWidget {

  const PasswordForm({Key? key})
    : super(key: key);

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final FocusNode _oldPasswordFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _passwordConfirmationFocus = FocusNode();


  late PasswordFormBloc _passwordFormBloc;

  @override
  void initState() {
    super.initState();
    _passwordFormBloc = BlocProvider.of<PasswordFormBloc>(context);
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: BlocBuilder<PasswordFormBloc, PasswordFormState>(
                  builder: (context, state) {
                    return KeyboardActions(
                      config: _buildKeyboard(state: state),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const ScreenTitle(title: 'Change Password'),
                          _currentPassword(state: state),
                          _newPassword(state: state),
                          _newPasswordConfirmation(state: state),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
                  },
                ) 
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  children: [
                    Expanded(
                      child: _cancelButton()
                    ),
                    SizedBox(width: 20.w),
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
    _oldPasswordFocus.dispose();
    _passwordFocus.dispose();
    _passwordConfirmationFocus.dispose();
    super.dispose();
  }

  Widget _currentPassword({required PasswordFormState state}) {
    return TextFormField(
      key: const Key("currentPasswordFieldKey"),
      decoration: InputDecoration(
        labelText: 'Current Password',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 25.sp
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 28.sp
      ),
      onChanged: (oldPassword) => _onOldPasswordChanged(oldPassword: oldPassword),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.send,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => !state.isOldPasswordValid && state.oldPassword.isNotEmpty
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
      key: const Key("newPasswordFieldKey"),
      decoration: InputDecoration(
        labelText: 'New Password',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 25.sp
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 28.sp
      ),
      onChanged: (password) => _onPasswordChanged(password: password),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => !state.isPasswordValid && state.password.isNotEmpty
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
      key: const Key("newPasswordConfirmationFieldKey"),
      decoration: InputDecoration(
        labelText: 'Password Confirmation',
        labelStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 25.sp
        )
      ),
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 28.sp
      ),
      onChanged: (passwordConfirmation) => _onPasswordConfirmationChanged(passwordConfirmation: passwordConfirmation),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      autocorrect: false,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (_) => !state.isPasswordConfirmationValid && state.passwordConfirmation.isNotEmpty
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
          key: const Key("cancelButtonKey"),
          onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(),
          child: ButtonText(text: 'Cancel', color: state.isSubmitting 
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
          key: const Key("submitButtonKey"),
          onPressed: _canSubmit(state: state) ? () => _submit(state: state) : null,
          child: _buttonChild(state: state),
        );
      },
    );
  }

  Widget _buttonChild({required PasswordFormState state}) {
    if (state.isSubmitting) {
      return SizedBox(height: 25.sp, width: 25.sp, child: const CircularProgressIndicator());
    } else {
      String text = state.isOldPasswordVerified ? 'Save' : 'Verify';
      return ButtonText(text: text);
    }
  }

  bool _canSubmit({required PasswordFormState state}) {
    if (state.isOldPasswordVerified) {
      return state.passwordFormValid && !state.isSubmitting;
    } else {
      return state.oldPasswordFormValid && !state.isSubmitting;
    }
  }

  void _submit({required PasswordFormState state}) {
    if (_canSubmit(state: state)) {
      state.isOldPasswordVerified 
        ? _passwordFormBloc.add(NewPasswordSubmitted())
        : _passwordFormBloc.add(OldPasswordSubmitted());
    }
  }
  
  void _onOldPasswordChanged({required String oldPassword}) {
    _passwordFormBloc.add(OldPasswordChanged(oldPassword: oldPassword));
  }

  void _onPasswordChanged({required String password}) {
    _passwordFormBloc.add(PasswordChanged(password: password));
  }

  void _onPasswordConfirmationChanged({required String passwordConfirmation}) {
    _passwordFormBloc.add(PasswordConfirmationChanged(passwordConfirmation: passwordConfirmation));
  }

  void _cancelButtonPressed() {
    Navigator.pop(context);
  }

  void _showSnackbar({required String message, required PasswordFormState state}) async  {
    bool isSuccess = state.isSuccess || state.isSuccessOldPassword;
    isSuccess ? Vibrate.success() : Vibrate.error();

    final SnackBar snackBar = SnackBar(
      key: const Key("passwordFormSnackbarKey"),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SnackbarText(text: message)
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
        KeyboardActionsItem(
          focusNode: _passwordFocus,
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
        KeyboardActionsItem(
          focusNode: _passwordConfirmationFocus,
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