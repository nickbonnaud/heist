import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:heist/models/customer/customer.dart';
import 'package:heist/resources/helpers/size_config.dart';
import 'package:heist/resources/helpers/text_styles.dart';
import 'package:heist/screens/password_screen/bloc/password_form_bloc.dart';
import 'package:heist/themes/global_colors.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:vibrate/vibrate.dart';

class PasswordForm extends StatefulWidget {
  final Customer _customer;

  PasswordForm({@required Customer customer})
    : assert(customer != null),
      _customer = customer;

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


  PasswordFormBloc _passwordFormBloc;

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordFormBloc, PasswordFormState>(
      listener: (context, state) {
        if (state.isSuccess) {
          String message = 'Password updated!';
          _showSnackbar(context, message, state);
        } else if (state.isFailure) {
          String message = 'Failed to change password. Please try again.';
          _showSnackbar(context, message, state);
        } else if (state.isFailureOldPassword) {
          String message = 'Failed to verify password. Please try again.';
          _showSnackbar(context, message, state);
        } else if (state.isSuccessOldPassword) {
          String message = 'Password verified.';
          _showSnackbar(context, message, state);
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
                      config: _buildKeyboard(context, state),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          VeryBoldText1(text: 'Change Password', context: context),
                          TextFormField(
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
                            autovalidate: true,
                            validator: (_) => !state.isOldPasswordValid && _oldPasswordController.text.isNotEmpty ? 'Invalid password' : null,
                            obscureText: true,
                            focusNode: _oldPasswordFocus,
                            onFieldSubmitted: (_) {
                              _submit(state);
                            },
                            enabled: !state.isOldPasswordVerified,
                          ),
                          TextFormField(
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
                            autovalidate: true,
                            validator: (_) => !state.isPasswordValid && _passwordController.text.isNotEmpty ? 'Invalid password' : null,
                            obscureText: true,
                            focusNode: _passwordFocus,
                            onFieldSubmitted: (_) {
                              _passwordFocus.unfocus();
                              FocusScope.of(context).requestFocus(_passwordConfirmationFocus);
                            },
                            enabled: state.isOldPasswordVerified,
                          ),
                          TextFormField(
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
                            autovalidate: true,
                            validator: (_) => !state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty ? 'Confirmation does not match' : null,
                            obscureText: true,
                            focusNode: _passwordConfirmationFocus,
                            onFieldSubmitted: (_) {
                              _passwordFocus.unfocus();
                            },
                            enabled: state.isOldPasswordVerified,
                          ),
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
                      child: BlocBuilder<PasswordFormBloc, PasswordFormState>(
                        builder: (context, state) {
                          return OutlineButton(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.buttonOutlineCancel
                            ),
                            disabledBorderColor: Theme.of(context).colorScheme.buttonOutlineCancelDisabled,
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: state.isSubmitting ? null : () => _cancelButtonPressed(context),
                            child: BoldText3(text: 'Cancel', context: context, color: state.isSubmitting 
                              ? Theme.of(context).colorScheme.buttonOutlineCancelDisabled
                              : Theme.of(context).colorScheme.buttonOutlineCancel
                            ),
                          );
                        },
                      )
                    ),
                    SizedBox(width: 20.0),
                    Expanded(
                      child: BlocBuilder<PasswordFormBloc, PasswordFormState>(
                        builder: (context, state) {
                          return RaisedButton(
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            onPressed: _canSubmit(state) ? () => _submit(state) : null,
                            child: _createButtonText(state),
                          );
                        },
                      )
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
  void initState() {
    super.initState();
    _passwordFormBloc = BlocProvider.of<PasswordFormBloc>(context);
    _oldPasswordController.addListener(_onOldPasswordChanged);
    _passwordController.addListener(_onPasswordChanged);
    _passwordConfirmationController.addListener(_onPasswordConfirmationChanged);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  bool _canSubmit(PasswordFormState state) {
    if (state.isOldPasswordVerified) {
      return state.isPasswordValid && _passwordController.text.isNotEmpty && state.isPasswordConfirmationValid && _passwordConfirmationController.text.isNotEmpty && !state.isSubmitting;
    } else {
      return state.isOldPasswordValid && _oldPasswordController.text.isNotEmpty && !state.isSubmitting;
    }
  }

  void _submit(PasswordFormState state) {
    if (_canSubmit(state)) {
      state.isOldPasswordVerified 
        ? _passwordFormBloc.add(NewPasswordSubmitted(
            oldPassword: _oldPasswordController.text,
            password: _passwordController.text,
            passwordConfirmation: _passwordConfirmationController.text,
            customer: widget._customer
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

  void _cancelButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _showSnackbar(BuildContext context, String message, PasswordFormState state) async  {
    bool canVibrate = await Vibrate.canVibrate;
    bool isSuccess = state.isSuccess || state.isSuccessOldPassword;
    if (canVibrate) {
      Vibrate.feedback(isSuccess ? FeedbackType.success : FeedbackType.error);
    }

    Scaffold.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: BoldText3(text: message, context: context, color: Theme.of(context).colorScheme.textOnDark)
              ),
              PlatformWidget(
                android: (_) => Icon(isSuccess ? Icons.check_circle_outline : Icons.error),
                ios: (_) => Icon(
                  IconData(
                    isSuccess ? 0xF3FE : 0xF35B,
                    fontFamily: CupertinoIcons.iconFont,
                    fontPackage: CupertinoIcons.iconFontPackage
                  ),
                  color: Theme.of(context).colorScheme.onError,
                ),
              )
            ],
          ),
          backgroundColor: isSuccess 
            ? Theme.of(context).colorScheme.success
            : Theme.of(context).colorScheme.error,
        )
      ).closed.then((_) => {
        if (state.isSuccess) {
          Navigator.of(context).pop()
        } else {
          BlocProvider.of<PasswordFormBloc>(context).add(Reset())
        }
      });
  }

  Widget _createButtonText(PasswordFormState state) {
    if (state.isSubmitting) {
      return TyperAnimatedTextKit(
        speed: Duration(milliseconds: 250),
        text: state.isOldPasswordVerified ? ['Saving...'] : ['Verifying'],
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.textOnDark,
          fontSize: SizeConfig.getWidth(6)
        ),
      );
    } else {
      String text = state.isOldPasswordVerified ? 'Save' : 'Verify';
      return BoldText3(text: text, context: context, color: Theme.of(context).colorScheme.textOnDark);
    }
  }

  KeyboardActionsConfig _buildKeyboard(BuildContext context, PasswordFormState state) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      actions: [
        if (!state.isOldPasswordVerified) 
          KeyboardAction(
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
        KeyboardAction(
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
        KeyboardAction(
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